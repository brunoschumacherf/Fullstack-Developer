import { fireEvent, render, screen } from "@testing-library/react"
import { useForm } from "@inertiajs/react"
import UserImportPanel from "../dashboard/UserImportPanel"
import type { ImportProps } from "../../types"

jest.mock("@inertiajs/react", () => ({ useForm: jest.fn() }))
jest.mock("../../hooks/useImportProgress", () => ({ __esModule: true, default: (value: ImportProps | null) => value }))
jest.mock("../../i18n", () => ({ useT: () => (key: string) => key }))
const setData = jest.fn()
const post = jest.fn()
const mockForm = useForm as unknown as jest.Mock<{ setData: typeof setData; post: typeof post; processing: boolean }>

beforeEach(() => mockForm.mockReturnValue({ setData, post, processing: false }))

it("submits the chosen spreadsheet as multipart data", () => {
  render(<UserImportPanel activeImport={null} />)
  const input = screen.getByLabelText("dashboard.import_title")
  const file = new File(["name,email"], "users.csv", { type: "text/csv" })
  fireEvent.change(input, { target: { files: [file] } })
  expect(setData).toHaveBeenCalledWith("file", file)
  fireEvent.submit(input.closest("form")!)
  expect(post).toHaveBeenCalledWith("/admin/user_imports", { forceFormData: true })
})

it("shows progress and limits the visible errors to eight", () => {
  const progress: ImportProps = { id: 1, status: "processing", total: 10, processed: 5, successful: 2, failed: 3, percentage: 50,
    errors: Array.from({ length: 10 }, (_, index) => `Error ${index}`) }
  render(<UserImportPanel activeImport={progress} />)
  expect(screen.getByText("50%")).toBeInTheDocument()
  expect(screen.getAllByRole("listitem")).toHaveLength(8)
  expect(screen.queryByText("Error 8")).not.toBeInTheDocument()
})

it("prevents duplicate submissions during upload", () => {
  mockForm.mockReturnValue({ setData, post, processing: true })
  render(<UserImportPanel activeImport={null} />)
  expect(screen.getByRole("button", { name: "dashboard.uploading" })).toBeDisabled()
})
