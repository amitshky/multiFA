document.addEventListener("DOMContentLoaded", () =>{
    const createAccountForm = document.querySelector("#createAccount");
});

userRegisterDetail = (Array.from(document.querySelectorAll('#registrationForm input')).reduce((acc, input)=>({...acc,[input.id]:input.value}), {}));
const userRegJson = JSON.stringify(userRegisterDetail);
console.log(userRegJson);

// document.addEventListener('submit',)