# 🎮 TMS Git Workshop - Student Activity Guide

## Prerequisites
- Git installed (check: `git --version`)
- A text editor (VS Code recommended)
- Terminal / Command Prompt

---

## 🔧 Setup

```bash
git clone <repo-url>
cd tms-git-workshop
git log --oneline   # See the initial commit
```

---

## Challenge 1: Feature Branch & Merge Conflict (20 min)

### Your Task:
Add a **new endpoint** to search users by email.

### Steps:

1. **Create a feature branch:**
   ```bash
   git checkout -b feature/search-by-email
   ```

2. **Edit `UserController.java`** — Add this method after `getUserById`:
   ```java
   @GetMapping("/search")
   public ResponseEntity<User> searchByEmail(@RequestParam String email) {
       User user = userService.findByEmail(email);
       return ResponseEntity.ok(user);
   }
   ```

3. **Edit `UserService.java`** — Add this method:
   ```java
   public User findByEmail(String email) {
       User user = userRepository.findByEmail(email);
       if (user == null) {
           throw new RuntimeException("User not found with email: " + email);
       }
       return user;
   }
   ```

4. **Commit:**
   ```bash
   git add .
   git commit -m "feat: add search by email endpoint"
   ```

5. **⚠️ Now the instructor will update main!** Wait for the signal...

6. **Try to merge main into your branch:**
   ```bash
   git fetch origin
   git merge origin/main
   ```

7. **💥 CONFLICT!** Open the conflicting files and resolve them:
   - Look for `<<<<<<<`, `=======`, `>>>>>>>` markers
   - Keep BOTH features (search by email AND search by department)
   - Remove the conflict markers

8. **Complete the merge:**
   ```bash
   git add .
   git commit -m "merge: resolve conflict with department search"
   ```

✅ **Done!** You handled your first merge conflict!

---

## Challenge 2: Rebase with Conflicts (25 min)

### Your Task:
Add **input validation** to the User service, then rebase onto updated main.

### Steps:

1. **Switch to main and pull latest:**
   ```bash
   git checkout main
   git pull origin main
   ```

2. **Create a new branch:**
   ```bash
   git checkout -b feature/add-validation
   ```

3. **Make multiple small commits** (this is intentional — we'll clean them up later):

   **Commit 1:** Edit `UserService.java` — modify `createUser`:
   ```java
   public User createUser(User user) {
       if (user.getName() == null || user.getName().isBlank()) {
           throw new IllegalArgumentException("Name is required");
       }
       return userRepository.save(user);
   }
   ```
   ```bash
   git add .
   git commit -m "wip: add name validation"
   ```

   **Commit 2:** Add email validation too:
   ```java
   public User createUser(User user) {
       if (user.getName() == null || user.getName().isBlank()) {
           throw new IllegalArgumentException("Name is required");
       }
       if (user.getEmail() == null || !user.getEmail().contains("@")) {
           throw new IllegalArgumentException("Valid email is required");
       }
       return userRepository.save(user);
   }
   ```
   ```bash
   git add .
   git commit -m "wip: add email validation"
   ```

   **Commit 3:** Add department validation:
   ```java
   public User createUser(User user) {
       if (user.getName() == null || user.getName().isBlank()) {
           throw new IllegalArgumentException("Name is required");
       }
       if (user.getEmail() == null || !user.getEmail().contains("@")) {
           throw new IllegalArgumentException("Valid email is required");
       }
       if (user.getDepartment() == null || user.getDepartment().isBlank()) {
           throw new IllegalArgumentException("Department is required");
       }
       return userRepository.save(user);
   }
   ```
   ```bash
   git add .
   git commit -m "fix: also validate department"
   ```

   **Commit 4:** Fix a typo (add it intentionally then fix):
   ```bash
   git add .
   git commit -m "fix typo"
   ```

4. **⚠️ Instructor updates main again!** Wait for signal...

5. **Rebase onto main:**
   ```bash
   git fetch origin
   git rebase origin/main
   ```

6. **💥 CONFLICTS during rebase!**
   - Git will pause at each conflicting commit
   - Resolve the conflict in the file
   - Then continue:
   ```bash
   git add .
   git rebase --continue
   ```
   - Repeat until rebase is complete

   💡 **If you mess up:** `git rebase --abort` starts over!

✅ **Done!** Notice how rebase replays YOUR commits one-by-one on top of main.

---

## Challenge 3: Interactive Rebase — Clean Up History (20 min)

### Your Task:
Your commit history from Challenge 2 is messy. Clean it up!

### Steps:

1. **View your commits:**
   ```bash
   git log --oneline -5
   ```
   You'll see something like:
   ```
   abc1234 fix typo
   def5678 fix: also validate department
   ghi9012 wip: add email validation
   jkl3456 wip: add name validation
   ```

2. **Start interactive rebase:**
   ```bash
   git rebase -i HEAD~4
   ```

3. **In the editor, change the plan:**
   ```
   pick jkl3456 wip: add name validation
   squash ghi9012 wip: add email validation
   squash def5678 fix: also validate department
   squash abc1234 fix typo
   ```

4. **Save and close.** Git will ask for a new commit message.

5. **Write a clean message:**
   ```
   feat: add input validation for user creation

   - Validates name is not blank
   - Validates email contains @
   - Validates department is not blank
   ```

6. **Verify:**
   ```bash
   git log --oneline -3
   ```
   You should now see ONE clean commit instead of four!

✅ **Done!** This is how pros keep their Git history clean before creating PRs.

---

## 🏆 Bonus Challenge: Disaster Recovery (10 min)

### Scenario:
Oh no! You accidentally ran `git reset --hard HEAD~2` and lost commits!

### Steps:

1. **Simulate the disaster:**
   ```bash
   git reset --hard HEAD~2
   git log --oneline   # Your commits are gone! 😱
   ```

2. **Use reflog to find them:**
   ```bash
   git reflog
   ```
   Find the commit hash from BEFORE the reset.

3. **Recover:**
   ```bash
   git reset --hard <commit-hash-from-reflog>
   git log --oneline   # They're back! 🎉
   ```

✅ **Lesson:** `git reflog` is your emergency recovery tool. It tracks everything!

---

## 📝 Cheat Sheet

| Command | What it does |
|---------|-------------|
| `git status` | See current state |
| `git log --oneline` | Compact history |
| `git diff` | See unstaged changes |
| `git stash` | Temporarily save work |
| `git rebase --abort` | Cancel a rebase |
| `git reflog` | See ALL history (safety net) |
| `git merge --abort` | Cancel a merge |

---

## 🤔 Discussion Questions

1. When would you use merge vs rebase?
2. Why is "never rebase shared branches" important?
3. How does clean commit history help in code reviews?
4. What's the difference between `git reset --soft`, `--mixed`, and `--hard`?

---

**Good luck and have fun! 🚀**
