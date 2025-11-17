//    string and numbers
//    let userName = 'Hi It\'s max';
//     let age = 32;
//     alert(userName);
//     userName = 'Learning Web dev';
//     alert(userName);
//     alert(age);

let age = 32;
let userName = "Max";
let hobbies = ["Sports", "Cooking", "Cleaning"];
let job = {
  title: "Developer",
  place: "India",
  salary: 50000,
};

let adultYears;

function calculateFUnction() {
  let ageChange = age - 18;
  return ageChange;
}

function addtheAgeFunction(nu)
{
    let change = nu + 19
    return change;
}
adultYears = calculateFUnction();
console.log(adultYears);

adultYears = addtheAgeFunction(20);
alert(adultYears);

// alert(job.title);

// function in object is called a method 
let person = {
  name:'ma',
  greet() {
    console.log('Good Night');
  }
};

person.greet();