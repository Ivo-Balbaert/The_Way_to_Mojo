use std::time::Instant;

fn main() {
    let mut list: Vec<i64> = vec!();
    for _ in 0..10_000 {
        list.push(1)
    }
    let tik = Instant::now();
    for i in 1..list.len() {
        list[i] += list[i - 1]
    }
    let tok = Instant::now();
    println!("Time spent per element: {:?} ns",
        ((tok - tik).as_nanos() as f64) / list.len() as f64)
}

// => Time spent per element: 9.752 ns
// rustc -O: Time spent per element: 2.488 ns