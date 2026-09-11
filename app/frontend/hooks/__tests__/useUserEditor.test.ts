import { renderHook } from "@testing-library/react"
import { useForm, usePage } from "@inertiajs/react"
import type { FormEvent } from "react"
import useUserEditor from "../useUserEditor"
import type { UserFormData } from "../../types/forms"

jest.mock("@inertiajs/react", () => ({ useForm: jest.fn(), usePage: jest.fn() }))
const setData = jest.fn()
const post = jest.fn()
type EditorPayload = { _method: string; user: UserFormData }
const mockForm = useForm as unknown as jest.Mock<{ data: EditorPayload; setData: typeof setData; post: typeof post; processing: boolean }, [EditorPayload]>
const user = { id: 2, full_name: "Morgan", email_address: "morgan@example.com", role: "member", avatar_url: "/avatar.png" }

beforeEach(() => {
  jest.mocked(usePage).mockReturnValue({ props: { errors: { full_name: "Required" } } } as unknown as ReturnType<typeof usePage>)
  // Only the Inertia transport boundary is stubbed; the editor builds the actual payload.
  mockForm.mockImplementation(initial => ({ data: initial, setData, post, processing: false }))
})

it("keeps role out of registration payloads and submits multipart data", () => {
  const { result } = renderHook(() => useUserEditor({ url: "/register" }))
  expect(result.current.data).not.toHaveProperty("role")
  expect(result.current.errors.full_name).toBe("Required")
  const preventDefault = jest.fn()
  result.current.onSubmit({ preventDefault } as unknown as FormEvent)
  expect(preventDefault).toHaveBeenCalled()
  expect(post).toHaveBeenCalledWith("/register", { forceFormData: true })
})

it("uses PATCH for edits and preserves sibling fields when changing a field", () => {
  const { result } = renderHook(() => useUserEditor({ user, url: "/profile" }))
  const initial = mockForm.mock.calls[0][0]
  expect(initial).toEqual(expect.objectContaining({ _method: "patch" }))
  result.current.setData("full_name", "Updated")
  const update = setData.mock.calls[0][0] as (value: { _method: string; user: UserFormData }) => unknown
  expect(update({ _method: "patch", user: result.current.data })).toEqual({
    _method: "patch", user: { ...result.current.data, full_name: "Updated" },
  })
  expect(result.current.data).not.toHaveProperty("role")
})

it("includes the role only for administrator forms", () => {
  const { result } = renderHook(() => useUserEditor({ user, url: "/admin/users/2", showRole: true }))
  expect(result.current.data.role).toBe("member")
})
