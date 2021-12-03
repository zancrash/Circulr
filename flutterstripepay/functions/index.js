const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const stripe = require('stripe')(functions.config().stripe.testkey);

exports.stripePayment = functions.https.onRequest(async (req, res) => {

    const paymentIntent = await stripe.paymentIntents.create({
        // amount: 2000,
        amount: parseInt(req.body.amount),
        currency: 'cad',
        payment_method_types: ['card'],
    },
        function(err, paymentIntent) {
            if(err!=null) {
                console.log(err);
            } else {
                res.json({
                    paymentIntent: paymentIntent.client_secret
                })
            }
        }
    )

    // const session = await stripe.checkout.sessions.create({
    //     payment_method_types: ['card'],
    //     mode: 'setup',
    //     customer: '{{CUSTOMER_ID}}',
    //     success_url: 'https://example.com/success?session_id={CHECKOUT_SESSION_ID}',
    //     cancel_url: 'https://example.com/cancel',
    //   });

})