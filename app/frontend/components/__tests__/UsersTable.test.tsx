import { fireEvent, render, screen } from "@testing-library/react"
import { router } from "@inertiajs/react"
import UsersTable from "../dashboard/UsersTable"
import type { AnchorHTMLAttributes } from "react"

jest.mock("@inertiajs/react", () => ({
  router: { patch: jest.fn(), delete: jest.fn() },
  Link: (props: AnchorHTMLAttributes<HTMLAnchorElement>) => <a {...props} />,
}))
jest.mock("../../i18n", () => ({ useT: () => (key: string) => key }))
const member = { id: 7, full_name: "Morgan", email_address: "morgan@example.com", role: "member", avatar_url: "/avatar.png" }

afterEach(() => jest.restoreAllMocks())

it.each([["member", "admin"], ["admin", "member"]])("toggles %s to %s", (role, expectedRole) => {
  render(<UsersTable users={[{ ...member, role }]} />)
  expect(screen.getByRole("link", { name: "dashboard.edit" })).toHaveAttribute("href", "/admin/users/7/edit")
  fireEvent.click(screen.getByRole("button", { name: "dashboard.toggle_role" }))
  expect(router.patch).toHaveBeenCalledWith("/admin/users/7", { user: { role: expectedRole } })
})

it("requires confirmation before deleting a user", () => {
  const confirm = jest.spyOn(window, "confirm").mockReturnValue(false)
  render(<UsersTable users={[member]} />)
  fireEvent.click(screen.getByRole("button", { name: "dashboard.delete" }))
  expect(router.delete).not.toHaveBeenCalled()
  confirm.mockReturnValue(true)
  fireEvent.click(screen.getByRole("button", { name: "dashboard.delete" }))
  expect(router.delete).toHaveBeenCalledWith("/admin/users/7")
})
