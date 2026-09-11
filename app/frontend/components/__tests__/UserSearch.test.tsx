import { fireEvent, render, screen } from "@testing-library/react"
import { router } from "@inertiajs/react"
import UserSearch from "../dashboard/UserSearch"

jest.mock("@inertiajs/react", () => ({ router: { get: jest.fn() } }))
jest.mock("../../i18n", () => ({ useT: () => (key: string) => key }))

it("sends a trimmed search and resets pagination", () => {
  const { rerender } = render(<UserSearch query="old" />)
  const input = screen.getByRole("searchbox")
  fireEvent.change(input, { target: { value: "  Morgan  " } })
  fireEvent.submit(screen.getByRole("search"))
  expect(router.get).toHaveBeenCalledWith("/admin/dashboard", { query: "Morgan" }, {
    preserveState: true, replace: true, only: ["users", "user_filters", "user_pagination"],
  })
  rerender(<UserSearch query="server value" />)
  expect(input).toHaveValue("server value")
})

it("removes the query when the search is cleared", () => {
  render(<UserSearch query="old" />)
  fireEvent.change(screen.getByRole("searchbox"), { target: { value: " " } })
  fireEvent.submit(screen.getByRole("search"))
  expect(router.get).toHaveBeenCalledWith("/admin/dashboard", {}, expect.any(Object))
})
