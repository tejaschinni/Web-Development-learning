let productNameElement = document.getElementById("product-name");
let remainingCharsElement = document.getElementById("remaining-chars");

let maxAllowedChars = productNameElement.maxLength;

function updateRemainingChars(event) {
  let enteredText = event.target.value;
  let enteredTextLength = enteredText.length;

  let remainingCharacters = maxAllowedChars - enteredTextLength;

  remainingCharsElement.textContent = remainingCharacters;
//   if (remainingCharacters > 40) {
//     // Green
//     remainingCharsElement.style.color = "rgb(0, 128, 0)";
//   } else if (remainingCharacters > 10) {
//     // Orange
//     remainingCharsElement.style.color = "rgb(255, 165, 0)";
//   } else {
//     // Red
//     remainingCharsElement.style.color = "rgb(255, 0, 0)";
//   }
}

productNameElement.addEventListener("input", updateRemainingChars);
