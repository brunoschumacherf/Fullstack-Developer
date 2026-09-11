import { render, screen } from "@testing-library/react"
import Pagination from "../dashboard/Pagination"
import type { AnchorHTMLAttributes } from "react"

jest.mock("@inertiajs/react", () => ({
  Link: ({ preserveState: _preserveState, only: _only, ...props }: AnchorHTMLAttributes<HTMLAnchorElement> & { preserveState?: boolean; only?: string[] }) => <a {...props} />,
}))
jest.mock("../../i18n", () => ({ useT: () => (key: string, vars?: { total?: number }) => vars?.total ? `${key}:${vars.total}` : key }))

it("preserves the query in page links and marks the current page", () => {
  render(<Pagination query="Morgan Member" pagination={{ page: 2, per_page: 10, total: 25, total_pages: 3 }} />)
  expect(screen.getByText("dashboard.results:25")).toBeInTheDocument()
  expect(screen.getByRole("link", { name: "2" })).toHaveAttribute("aria-current", "page")
  expect(screen.getByRole("link", { name: "3" })).toHaveAttribute("href", "/admin/dashboard?query=Morgan+Member&page=3")
})

it("does not render navigation for one page", () => {
  const { container } = render(<Pagination query="" pagination={{ page: 1, per_page: 10, total: 3, total_pages: 1 }} />)
  expect(container).toBeEmptyDOMElement()
})
