const MODE = import.meta.env.MODE;
const BASE_URL = MODE == "development" ? "https://assigndb.hah4.id.vn" : "";

async function apiCall(path, method = "GET", body = null) {
    let res = await fetch(BASE_URL + path, {
        method,
        headers: {
            "Content-Type": "application/json",
        },
        credentials: "include",
        body: body ? JSON.stringify(body) : null,
    }).then((res) => {
        if (res.headers.get("Content-Type").includes("application/json")) {
            return res.json();
        } else {
            return res.text();
        }
    });
    return res;
}

export default apiCall;

/*
let res = await apiCall("/api/auth/login", "POST", {
    username: "user1",
    password: "demo"
})

*/
