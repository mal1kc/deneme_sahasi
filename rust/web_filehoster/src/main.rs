use std::path::PathBuf;

use ascii::AsciiString;
use std::fs;
use std::path::Path;

fn get_content_type(path: &Path) -> &'static str {
    let extension = match path.extension() {
        None => return "text/plain",
        Some(e) => e,
    };

    match extension.to_str().unwrap() {
        "gif" => "image/gif",
        "jpg" => "image/jpeg",
        "jpeg" => "image/jpeg",
        "png" => "image/png",
        "pdf" => "application/pdf",
        "htm" => "text/html; charset=utf8",
        "html" => "text/html; charset=utf8",
        "txt" => "text/plain; charset=utf8",
        _ => "text/plain; charset=utf8",
    }
}

fn main() {
    let server = tiny_http::Server::http("0.0.0.0:8000").unwrap();
    let port = server.server_addr().to_ip().unwrap().port();
    println!("Now listening on port {}", port);

    loop {
        let rq = match server.recv() {
            Ok(rq) => rq,
            Err(_) => break,
        };

        println!("{:?}", rq);

        let url = rq.url().to_string();
        let path = PathBuf::from(&url[1..]); // remove the leading '/'

        let file = fs::File::open(&path);
        let file_is_ok: bool = file.is_ok();
        // && path.components().any(|comp| comp.as_os_str() == "..");
        println!("{:?}", file_is_ok);

        if file_is_ok {
            let response = tiny_http::Response::from_file(file.unwrap());

            let response = response.with_header(tiny_http::Header {
                field: "Content-Type".parse().unwrap(),
                value: AsciiString::from_ascii(get_content_type(&path)).unwrap(),
            });

            let _ = rq.respond(response);
        } else {
            let rep = tiny_http::Response::new_empty(tiny_http::StatusCode(404));
            let _ = rq.respond(rep);
        }
    }
}
