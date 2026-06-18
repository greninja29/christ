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
```

### Pick your team branch:
```bash
# Team Alpha students:
git checkout team-alpha

# Team Beta students:
git checkout team-beta
```

⚠️ **main is LOCKED — no one pushes to main directly!**

```bash
git log --oneline   # See the initial commits on your team branch
```

---

## Activity 0: Basic Git Commands Practice (10 min)

### Warm-up — learn the fundamentals in a scratch repo:

```bash
mkdir my-practice && cd my-practice && git init
```

1. **Create a file & check status:**
   ```bash
   echo "Hello Git" > hello.txt
   git status              # hello.txt is UNTRACKED (red)
   ```

2. **Stage it:**
   ```bash
   git add hello.txt
   git status              # hello.txt is STAGED (green)
   ```

3. **Commit it:**
   ```bash
   git commit -m "Add hello.txt"
   git log --oneline       # Your first commit!
   ```

4. **Make a change & see the diff:**
   ```bash
   echo "Second line" >> hello.txt
   git diff                # Shows working dir vs last commit
   ```

5. **Stage & commit again:**
   ```bash
   git add hello.txt
   git diff --staged       # Shows what's about to be committed
   git commit -m "Add second line to hello.txt"
   git log --oneline       # Two commits!
   ```

✅ **Done!** Now go back to the workshop repo:
```bash
cd ../tms-git-workshop
```

---

## Challenge 1: Feature Branch & Merge Conflict (20 min)

### Your Task:
Add a **new endpoint** to search users by email.

### Steps:

1. **Make sure you're on your team branch:**
   ```bash
   git checkout team-alpha   # or team-beta
   ```

2. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-name-search-email
   ```

3. **Edit `UserController.java`** — Add this method after `getUserById`:
   ```java
   @GetMapping("/search")
   public ResponseEntity<User> searchByEmail(@RequestParam String email) {
       User user = userService.findByEmail(email);
       return ResponseEntity.ok(user);
   }
   ```

4. **Edit `UserService.java`** — Add this method:
   ```java
   public User findByEmail(String email) {
       User user = userRepository.findByEmail(email);
       if (user == null) {
           throw new RuntimeException("User not found with email: " + email);
       }
       return user;
   }
   ```

5. **Commit & push:**
   ```bash
   git add .
   git commit -m "feat: add search by email endpoint"
   git push origin feature/your-name-search-email
   ```

6. **⚠️ Now the instructor will update your team branch!** Wait for the signal...

7. **Try to merge your team branch into your feature branch:**
   ```bash
   git fetch origin
   git merge origin/team-alpha   # or origin/team-beta
   ```

8. **💥 CONFLICT!** Open the conflicting files and resolve them:
   - Look for `<<<<<<<`, `=======`, `>>>>>>>` markers
   - Keep BOTH features (search by email AND search by department)
   - Remove the conflict markers

9. **Complete the merge:**
   ```bash
   git add .
   git commit -m "merge: resolve conflict with department search"
   git push origin feature/your-name-search-email
   ```

✅ **Done!** You handled your first merge conflict!

---

## Challenge 2: Rebase with Conflicts (25 min)

### Your Task:
Add **input validation** to the User service, then rebase onto updated team branch.

### Steps:

1. **Switch to your team branch and pull latest:**
   ```bash
   git checkout team-alpha   # or team-beta
   git pull origin team-alpha
   ```

2. **Create a new branch:**
   ```bash
   git checkout -b feature/your-name-validation
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

4. **⚠️ Instructor updates your team branch again!** Wait for signal...

5. **Rebase onto team branch:**
   ```bash
   git fetch origin
   git rebase origin/team-alpha   # or origin/team-beta
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

✅ **Done!** Notice how rebase replays YOUR commits one-by-one on top of the team branch.

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
