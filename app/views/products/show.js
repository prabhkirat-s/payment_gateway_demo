export default function () {
  console.log("Hello from MyModule.js");
}

// import { loadStripe } from "@stripe/stripe-js";

// document.addEventListener("turbolinks:load", function () {
//   const stripe = loadStripe("YOUR_PUBLISHABLE_KEY");
//   const elements = stripe.elements();

//   const card = elements.create("card");
//   card.mount("#card-element");

//   card.addEventListener("change", function (event) {
//     const displayError = document.getElementById("card-errors");
//     if (event.error) {
//       displayError.textContent = event.error.message;
//     } else {
//       displayError.textContent = "";
//     }
//   });

//   const form = document.getElementById("payment-form");
//   form.addEventListener("submit", async function (event) {
//     event.preventDefault();

//     const { token, error } = await stripe.createToken(card);
//     if (error) {
//       const errorElement = document.getElementById("card-errors");
//       errorElement.textContent = error.message;
//     } else {
//       // Send the token to your server.
//       // You can access the token ID with token.id.
//       console.log(token.id);

//       // Send the token to your server via AJAX or form submission.
//       // e.g., createCharge(token.id);
//     }
//   });
// });
