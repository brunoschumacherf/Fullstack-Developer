import { fireEvent, render, screen } from "@testing-library/react"
import userEvent from "@testing-library/user-event"
import UserForm from "../UserForm"
import type { UserFormProps } from "../../types/forms"

jest.mock("../../i18n", () => ({ useT: () => (key: string) => key }))

const props: UserFormProps = {
  data: { full_name: "Morgan", email_address: "morgan@example.com", password: "", password_confirmation: "", avatar_url: "", avatar: null },
  setData: jest.fn(), onSubmit: jest.fn(event => event.preventDefault()), processing: false, errors: {}, submitLabel: "Save",
}

it("connects fields and uploads to their typed callbacks", async () => {
  const user = userEvent.setup()
  render(<UserForm {...props} />)
  fireEvent.change(screen.getByLabelText("forms.full_name"), { target: { value: "Updated" } })
  expect(props.setData).toHaveBeenCalledWith("full_name", "Updated")
  const avatar = new File(["image"], "avatar.png", { type: "image/png" })
  await user.upload(screen.getByLabelText("forms.avatar_upload"), avatar)
  expect(props.setData).toHaveBeenCalledWith("avatar", avatar)
  expect(screen.queryByRole("combobox")).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole("button", { name: "Save" }))
  expect(props.onSubmit).toHaveBeenCalled()
})

it("shows accessible server errors, required passwords and the admin role selector", () => {
  render(<UserForm {...props} showRole requirePassword errors={{ email_address: ["Invalid", "Taken"], password_confirmation: "Mismatch" }} />)
  expect(screen.getByLabelText("forms.email")).toHaveAccessibleDescription("Invalid, Taken")
  expect(screen.getByLabelText("forms.email")).toHaveAttribute("aria-invalid", "true")
  expect(screen.getByLabelText("forms.password")).toBeRequired()
  expect(screen.getByLabelText("forms.password_confirmation")).toHaveAccessibleDescription("Mismatch")
  fireEvent.change(screen.getByRole("combobox"), { target: { value: "admin" } })
  expect(props.setData).toHaveBeenCalledWith("role", "admin")
})

it("disables saving while processing", () => {
  render(<UserForm {...props} processing />)
  expect(screen.getByRole("button", { name: "forms.saving" })).toBeDisabled()
})
