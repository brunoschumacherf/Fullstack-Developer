import { act, renderHook } from "@testing-library/react"
import { router } from "@inertiajs/react"
import getConsumer from "../../channels/consumer"
import useImportProgress from "../useImportProgress"
import useDashboardStats from "../useDashboardStats"
import type { ImportProps, StatsProps } from "../../types"

jest.mock("@inertiajs/react", () => ({ router: { reload: jest.fn() } }))
jest.mock("../../channels/consumer", () => ({ __esModule: true, default: jest.fn() }))
const mockedGetConsumer = jest.mocked(getConsumer)
const create = jest.fn()
const progress: ImportProps = { id: 1, status: "pending", total: 3, processed: 0, successful: 0, failed: 0, percentage: 0, errors: [] }
const unsubscribe = jest.fn()

beforeEach(() => {
  mockedGetConsumer.mockReturnValue({ subscriptions: { create } } as ReturnType<typeof getConsumer>)
  create.mockReturnValue({ unsubscribe })
})

it("subscribes when an import arrives through new page props", () => {
  const { result, rerender, unmount } = renderHook(({ value }) => useImportProgress(value), { initialProps: { value: null as ImportProps | null } })
  expect(create).not.toHaveBeenCalled()
  rerender({ value: progress })
  expect(create).toHaveBeenCalledWith({ channel: "ImportProgressChannel", id: 1 }, expect.any(Object))
  expect(result.current).toEqual(progress)
  unmount()
  expect(unsubscribe).toHaveBeenCalledTimes(1)
})

it.each(["completed", "failed"])("reloads the dashboard and unsubscribes when the import is %s", status => {
  const { result } = renderHook(() => useImportProgress(progress))
  const received = create.mock.calls[0][1]?.received as (value: ImportProps) => void
  act(() => received({ ...progress, status, percentage: 100 }))
  expect(result.current?.status).toBe(status)
  expect(router.reload).toHaveBeenCalledWith({ only: ["users", "stats", "active_import"] })
  expect(unsubscribe).toHaveBeenCalledTimes(1)
  expect(create).toHaveBeenCalledTimes(1)
})

it("updates running imports without reloading or resubscribing", () => {
  const running = { ...progress, status: "processing" }
  const { result } = renderHook(() => useImportProgress(running))
  const received = create.mock.calls[0][1]?.received as (value: ImportProps) => void
  act(() => received({ ...progress, status: "processing", percentage: 50 }))
  expect(result.current?.percentage).toBe(50)
  expect(router.reload).not.toHaveBeenCalled()
  expect(create).toHaveBeenCalledTimes(1)
})

it("replaces the subscription when another import is supplied", () => {
  const { rerender } = renderHook(({ value }) => useImportProgress(value), { initialProps: { value: progress } })
  rerender({ value: { ...progress, id: 2 } })
  expect(unsubscribe).toHaveBeenCalledTimes(1)
  expect(create).toHaveBeenLastCalledWith({ channel: "ImportProgressChannel", id: 2 }, expect.any(Object))
})

it("updates stats from both broadcasts and refreshed props", () => {
  const initial = { total_users: 3, role_counts: { admin: 1, member: 2 } }
  const { result, rerender, unmount } = renderHook(({ stats }) => useDashboardStats(stats), { initialProps: { stats: initial } })
  const received = create.mock.calls[0][1]?.received as (value: StatsProps) => void
  act(() => received({ ...initial, total_users: 4 }))
  expect(result.current.total_users).toBe(4)
  rerender({ stats: { ...initial, total_users: 5 } })
  expect(result.current.total_users).toBe(5)
  unmount()
  expect(unsubscribe).toHaveBeenCalledTimes(1)
})
