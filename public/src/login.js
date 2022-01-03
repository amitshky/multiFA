let messages = []

function setFormMessage(formElement, type, message) {
        const messageElement = formElement.querySelector(".form__messsage");
        messageElement.textContent = message;
        messageElement.classList.remove("form__message--success","form__message--error");
        messageElement.classList.add(`form__message--${type}`);

}

document.addEventListener("DOMContentLoaded", () =>{
    const loginForm = document.querySelector("#login");
});

document.addEventListener('submit',function (evt) {
    evt.preventDefault();
    const userLoginDetail = (Array.from(document.querySelectorAll('#loginForm input')).reduce((acc, input)=>({...acc,[input.id]:input.value}), {}));
    const userLoginJson = JSON.stringify(userLoginDetail);
    console.log(userLoginJson);
    
})


// if (userLoginDetail.password.length < 8) {
//     messages.push('please enter a valid password')
// }

// console.log(userLoginJson);