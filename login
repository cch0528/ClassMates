<!DOCTYPE html>
<html lang="zh-HK">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CoachUp HK — 登入</title>
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;700&family=Noto+Sans+HK:wght@400;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="loginwrap">
  <div class="logo">Coach<span>Up</span> HK</div>
  <div class="tag">興趣班・搵教練・即刻book</div>

  <div class="rolepick" id="rolepick">
    <div class="rp on" data-r="student">🙋 學員</div>
    <div class="rp" data-r="coach">🏋️ 教練</div>
    <div class="rp" data-r="admin">🛠️ Admin</div>
  </div>

  <div class="frm">
    <label>Email</label>
    <input id="email" type="email" placeholder="you@email.com" autocomplete="username">
    <label>密碼</label>
    <input id="pw" type="password" placeholder="••••" autocomplete="current-password">
    <button class="btn primary block" id="loginBtn">登入</button>
    <button class="btn ghost block" id="regBtn">註冊新帳戶</button>
  </div>

  <div class="hint">
    <b>Demo帳戶</b>(密碼一律 1234):<br>
    學員 student@demo.com<br>
    教練 coach@demo.com<br>
    Admin admin@demo.com<br><br>
    <span style="opacity:.75">Demo mode:資料存喺本機。想reset所有資料 → </span>
    <a href="#" id="resetLink" style="color:var(--green)">撳呢度</a>
  </div>
</div>

<script src="app.js"></script>
<script>
let role = "student";
document.querySelectorAll("#rolepick .rp").forEach(el=>{
  el.onclick = ()=>{
    document.querySelectorAll("#rolepick .rp").forEach(x=>x.classList.remove("on"));
    el.classList.add("on"); role = el.dataset.r;
  };
});
const dest = r => ({student:"student.html", coach:"coach.html", admin:"admin.html"}[r]);

document.getElementById("loginBtn").onclick = ()=>{
  const email = document.getElementById("email").value.trim().toLowerCase();
  const pw = document.getElementById("pw").value;
  const db = DB.get();
  const u = db.users.find(x=>x.email===email && x.pw===pw);
  if(!u) return toast("Email或密碼唔啱");
  if(u.role!==role) return toast(`呢個帳戶係「${{student:"學員",coach:"教練",admin:"Admin"}[u.role]}」,請揀返啱嘅身份`);
  if(u.status==="disabled") return toast("帳戶已被停用,請聯絡平台");
  Session.set({uid:u.uid, role:u.role, name:u.name});
  location.href = dest(u.role);
};

document.getElementById("regBtn").onclick = ()=>{
  const email = document.getElementById("email").value.trim().toLowerCase();
  const pw = document.getElementById("pw").value;
  if(!email || !pw) return toast("填埋Email同密碼先");
  if(role==="admin") return toast("Admin帳戶唔開放註冊");
  const name = prompt("你嘅名/稱呼:");
  if(!name) return;
  const db = DB.get();
  if(db.users.find(x=>x.email===email)) return toast("呢個Email已註冊");
  const uid = DB.uid();
  DB.update(d=>{
    d.users.push({uid, role, name, email, pw, phone:"", status:"active"});
    if(role==="coach"){
      d.coaches.push({uid, name, em:"🏅", cat:"other", sub:"", region:d.regions[0], bio:"", quals:[], lessons:0,
        rating:0, ratingCount:0, bookingCount:0, approved:false, confirmMode:"default",
        featured:{pinned:false,pinOrder:0}, fps:"", payme:"", classes:[]});
    }
  });
  Session.set({uid, role, name});
  toast(role==="coach" ? "已註冊!教練帳戶需等Admin審批先會喺平台出現" : "註冊成功!");
  setTimeout(()=>location.href = dest(role), 900);
};

document.getElementById("resetLink").onclick = e=>{
  e.preventDefault();
  if(confirm("Reset晒所有demo資料?")){ resetDB(); Session.clear(); toast("已reset"); }
};
</script>
</body>
</html>
