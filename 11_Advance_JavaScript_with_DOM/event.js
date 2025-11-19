let paragraphElement = document.querySelector("p");
let inputElement = document.querySelector("input");


function changeParagraphText(){
    if(paragraphElement.textContent === "Click Me"){
        paragraphElement.textContent = "You Clicked Me";
    } else {
        paragraphElement.textContent = "Click Me";
    }
}

function retrieveUserInput(event){
    // let enteredText = inputElement.value;
    let enteredText = event.target.value;
    console.log(enteredText);
    console.log(event);
}

paragraphElement.addEventListener("click", changeParagraphText);

inputElement.addEventListener("input", retrieveUserInput);
