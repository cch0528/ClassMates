/* ===== Firebase 初始化 =====
   用 compat SDK(用<script>載入,唔使npm/bundler,適合純HTML項目) */
const firebaseConfig = {
  apiKey: "AIzaSyAPnAvTwNaJgCPsyg8dCzsRiKV-UddpcvM",
  authDomain: "classmates-61b19.firebaseapp.com",
  projectId: "classmates-61b19",
  storageBucket: "classmates-61b19.firebasestorage.app",
  messagingSenderId: "1085290223356",
  appId: "1:1085290223356:web:159bfd39e560c7f6d3a979",
  measurementId: "G-L7H3CZ5HGM"
};

firebase.initializeApp(firebaseConfig);
const fbAuth = firebase.auth();
const fbDB = firebase.firestore();
const fbStorage = firebase.storage();

/* ---------- Firestore 帳戶profile helpers ---------- */
async function fbCreateProfile(uid, data){
  await fbDB.collection("users").doc(uid).set({...data, createdAt:new Date().toISOString()});
}
async function fbGetProfile(uid){
  const snap = await fbDB.collection("users").doc(uid).get();
  return snap.exists ? snap.data() : null;
}