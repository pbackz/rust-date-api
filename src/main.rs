#![feature(proc_macro_hygiene, decl_macro)]
#[macro_use] extern crate rocket;
use chrono::prelude::*;
use rocket::State;
pub mod static_time;

// Initialisation d'une struct globale de type String pour usage dans la fonction now()
struct JsonDate(std::string::String);

#[get("/now")]
fn now(state: State<JsonDate>) -> std::string::String { // Récupération des valeurs depuis l'appel à la méthode manage, permis par rocket::State
    format!("{}", state.0)
}

fn main() {
    // Récupération de l'heure UTC du système
    let utc = Utc::now();
    // Formattage de la chaîne en date human readable et parsing de la struct utc en str
    let pretty_utc = &utc.format("%c").to_string();
    // Concaténation des délimiteurs JSON et de la chaîne utc
    let res : std::string::String = r#"{ "DateTime": ""#.to_owned() + pretty_utc + r#"" }"#;

    rocket::ignite()
    .manage(JsonDate(res.to_string()))
    .mount("/", routes![now, crate::static_time::static_time::literal_date]) //Attention ici à l'appel de la fonction par le namespace full du module
    .launch();
}
