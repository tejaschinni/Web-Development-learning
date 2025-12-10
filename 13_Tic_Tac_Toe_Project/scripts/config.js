function openPlayerConfig(event) 
{
   editedPlayer = +event.target.dataset.playerid;
  
  playerConstantOverlayElement.style.display = "block";
  backDropElement.style.display = "block";
  
}

function closePlayerConfig() {
  playerConstantOverlayElement.style.display = "none";
  backDropElement.style.display = "none";
  formElement.firstElementChild.classList.remove('error');
  errorOutputElement.textContent = '';
  formElement.firstElementChild.lastElementChild.value = '';
}

function savePlayerConfig(event){
  event.preventDefault(); //prevent the reload of the page 
  const formData = new FormData(event.target);
  const enteredPlayerName = formData.get('playername').trim();

  if(!enteredPlayerName){
    event.target.firstElementChild.classList.add('error');
    errorOutputElement.textContent = 'Please enter the valid name.'
    return;
  }
  console.log('player-'+editedPlayer+'-data');
  const updatedPlayerDataElement = document.getElementById('player-'+editedPlayer+'-data');
  console.log(updatedPlayerDataElement);
  updatedPlayerDataElement.children[1].textContent = enteredPlayerName;

//  if(editedPlayer === 1){
//   players[0].name = enteredPlayerName;
//  }else{
//   players[1].name = enteredPlayerName
//  }

players[editedPlayer - 1].name = enteredPlayerName;
closePlayerConfig();

}


