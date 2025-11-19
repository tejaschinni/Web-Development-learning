// window and document - In-build variable and Function

// console.log(window);

//DOM(Document Object Model)
// The Data representation of the parsed HTML code 

// console.log(document);

// document.body.children[1].children[0].href = 'https://www.google.com/';
// console.log(document.body.children[1].children[0]);

let linkElement = document.getElementById('external-link');

linkElement.href = 'https://www.google.com/'

linkElement = document.querySelector('#external-link');
linkElement.href = "https://www.youtube.com/"

// selecting DOM Elements 
//1 drill into elements
//2 Query Elements


// Add element via js
let newElement = document.createElement('a');
newElement.textContent = "add the element";

let firstParagraph = document.querySelector('p');

firstParagraph.append(newElement);

// delete elements
 let firstH1Element = document.querySelector('h1');
//  firstH1Element.remove();


// move elements 
firstParagraph.parentElement.append(firstParagraph);


// innerHTML
firstParagraph.innerHTML = 'This is the <strong>First</strong> Paragraph';





