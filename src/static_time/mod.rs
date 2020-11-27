pub mod static_time {
  #[get("/literal_date")]
  pub fn literal_date () -> &'static str {
    r##"Fri Nov 27 13:50:01 2020"##
  }
}