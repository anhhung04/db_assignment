const BASE_URL = "https://assigndb.hah4.id.vn"

async function apiCall(
    path,
    method = "GET",
    body = null
) {
    let res = await fetch(
        path,
        {
            method,
            headers: {
                "Content-Type": "application/json"
            }, credentials: true,
            body: JSON.stringify(body)
        }
    ).then(res => res.json())
    return res;
}

export default apiCall;

/*
let res = await apiCall("/api/auth/login", "POST", {
    username: "user1",
    password: "demo"
})

*/