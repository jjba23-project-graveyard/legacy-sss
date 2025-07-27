;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

text-mode :when (bound-and-true-p git-commit-mode)

(feature-commit "# Introduce a new feature" n "#" n
         "✨ feature: " p n n p n n
          "Keywords: " p)

(bug-commit "# Fix a bug" n "#" n
     "🐛 bug: " p n n p n n
      "Keywords: " p)

(docs-commit "# Update documentation" n "#" n
      "📝 docs: " p n n p n n
       "Keywords: " p)

(style-commit "# Code and formatting style changes" n "#" n
       "🎨 style: " p n n p n n
       "Keywords: " p)

(refactor-commit "# Code refactor" n "#" n
                 "♻️ refactor: " p n n p n n
                 "Keywords: " p)

(performance-commit "# Improve performance" n "#" n
                    "🚀 performance: " p n n p n n
                    "Keywords: " p)



;; ✅ :white_check_mark: test: (Tests) Adding missing tests or correcting existing tests.
;; 🔧 :wrench: chore: (Chore) Other changes that don't modify src or test files (e.g., build process, auxiliary tools, libraries).
;; ⏪️ :rewind: revert: (Revert) Reverts a previous commit.
;; ➕ :heavy_plus_sign: dep_add: (Dependency Add) Adds a dependency.
;; ➖ :heavy_minus_sign: dep_rm: (Dependency Remove) Removes a dependency.
;; ⬆️ :arrow_up: dep_up: (Dependency Update) Updates a dependency.
;; 🗑️ :wastebasket: rm: (Remove) Deletes code or files.
;; 🚧 :construction: wip: (Work In Progress) Commit that is still in development (use sparingly).
;; 📦 :package: build: (Build) Changes that affect the build system or external dependencies.
