use std::net::SocketAddr;

use axum::{routing::get, Router};
use once_cell::sync::Lazy;
use tokio::sync::{
    oneshot::{self, Sender},
    Mutex,
};

static SENDER: Lazy<Mutex<Vec<Sender<()>>>> = Lazy::new(|| Mutex::new(Vec::default()));

#[tokio::main]
pub async fn start_server() {
    let (s, r) = oneshot::channel();

    SENDER.lock().await.push(s);

    tokio::select! {
        _ = run_server() => {println!("Unexpcted")}
        _ = r => {println!("cancelled")}
    };
}

#[tokio::main]
pub async fn stop_server() {
    if let Some(sender) = SENDER.lock().await.pop() {
        sender.send(()).ok();
    }
}

// basic handler that responds with a static string
async fn root() -> &'static str {
    "Hello, World!"
}

async fn run_server() {
    println!("starting server");

    // build our application with a route
    let app = Router::new()
        // `GET /` goes to `root`
        .route("/", get(root));

    let addr: SocketAddr = SocketAddr::from(([127, 0, 0, 1], 3000));
    // run our app with hyper
    // `axum::Server` is a re-export of `hyper::Server`
    let server = axum::Server::bind(&addr).serve(app.into_make_service());
    // let graceful = server.with_graceful_shutdown(async {
    //     println!("Server Shutting down");
    // });
    // graceful.await.expect("Could not create server");
    server.await.expect("Could not create server");
}
