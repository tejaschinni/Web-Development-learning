const playerConstantOverlayElement = document.getElementById('config-overlay');
const backDropElement = document.getElementById('backdrop');



const editPlayer1BtnElement = document.getElementById("edit-player-1-btn");
const editPlayer2BtnElement = document.getElementById("edit-player-2-btn");
const cancelConfigElement = document.getElementById("cancel-config-btn");

editPlayer1BtnElement.addEventListener('click',openPlayerConfig);
editPlayer2BtnElement.addEventListener('click',openPlayerConfig);

cancelConfigElement.addEventListener('click', closePlayerConfig);
backDropElement.addEventListener('click', closePlayerConfig);