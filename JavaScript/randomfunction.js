const crypto = require('crypto');


//for input value for KYC varification

function hashInput(name, nationalId) {
  try {
    const textToHash = name + nationalId;
    const hash = crypto.createHash('sha256');
    hash.update(textToHash);
    return hash.digest('hex');
  } catch (error) {
    console.error("Error:", error);
    return null; // You can choose to handle the error as needed
  }
}

// Example usage: check the HASH value
const name = "Istiaque Ahmed";
const nationalId = "1234567890";
const hashedValue = hashInput(name, nationalId);

if (hashedValue !== null) {
  console.log("Hashed value:", hashedValue);
}

//random function to pass the value into the KYC module

function randomDelay(callback) {
    // Generate a random delay between 1 and 5 seconds (you can adjust this range)
    const delayMilliseconds = Math.floor(Math.random() * 4000) + 1000;
  
    // Record the start time
    const startTime = Date.now();
  
    // Use setTimeout to introduce the delay
    setTimeout(() => {
      // Calculate the end time
      const endTime = Date.now();
      
      // Calculate the actual delay
      const actualDelay = endTime - startTime;
  
      callback(actualDelay); // Execute the callback function with the actual delay
    }, delayMilliseconds);
  }
  

//Pass the HASH vakue and input value for KYC varification using random delay

randomDelay((actualDelay) => {
    const hashedValueOut = hashInput(name, nationalId);
    if (hashedValueOut !== null) {
      console.log("Actual Delay (milliseconds):", actualDelay);
      console.log("Hashed value after delay:", hashedValueOut);
      
    if(hashedValue==hashedValueOut)
    {
        console.log("Both Hash are same no attack");
        // Pass the hashed value to your KYC module here
    }
    else
    {
        console.log("Hash mitchmatched discard the input");
    }

    }
  });



