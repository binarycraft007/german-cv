#import "@preview/fontawesome:0.6.0": *

#let color-sidebar-bg = rgb("#2e3a4e")
#let color-text-white = rgb("#ffffff")
#let color-text-dark = rgb("#333333")
#let color-text-gray = rgb("#666666")
#let color-profile-ring = rgb(92, 111, 140) // Lighter Blue for ring

#let font-heading = ("Source Sans 3", "Noto Sans", "Liberation Sans")
#let font-body = ("Source Sans 3", "Noto Sans", "Liberation Sans")

#let icon(name) = {
  fa-icon(name, fill: color-text-white)
}

#let sidebar-header(title) = {
  set text(fill: color-text-white, weight: "bold", size: 13pt, font: font-heading)
  block(below: 0.8em, above: 0.8em)[
    #upper(title)
    #v(-3pt)
    #line(length: 100%, stroke: 1pt + color-text-white)
  ]
}

#let sidebar-item(title, subtitle, dates: none) = {
  set text(fill: color-text-white, size: 9pt)
  block(below: 1.5em)[
    #if dates != none {
      text(style: "italic", size: 9pt, fill: rgb(255,255,255,180))[#dates \ ]
    }
    #text(weight: "bold", size: 11pt)[#title]
    #v(2pt)
    #subtitle
  ]
}

#let language-item(title, level) = {
  set text(fill: color-text-white, size: 9pt)
  block(below: 0.6em, width: 100%)[
    #grid(
      columns: (1fr, auto),
      align: horizon,
      text(weight: "bold", size: 10pt)[#title],
      text(style: "italic", fill: rgb(255,255,255,180))[#level]
    )
  ]
}

#let skill-bar(name, percentage) = {
  set text(fill: color-text-white, size: 9pt, weight: "bold")
  block(below: 0.6em, width: 100%)[
    #grid(
      columns: (1fr, 1.2fr), 
      gutter: 10pt,
      align: horizon,
      align(left)[#name],
      box(
        width: 100%, 
        height: 3pt, 
        radius: 2pt, 
        fill: rgb(255, 255, 255, 40)
      )[
        #box(
          width: percentage * 1%, 
          height: 100%, 
          radius: 2pt, 
          fill: color-text-white
        )
      ]
    )
  ]
}

#let main-header(title) = {
  set text(fill: color-text-dark, weight: "bold", size: 16pt, font: font-heading)
  block(below: 1em, above: 2em)[
    #title
    #v(-3pt)
    #line(length: 100%, stroke: 1pt + color-text-gray)
  ]
}

#let experience-entry(
  title: "",
  company: "",
  date: "",
  location: "",
  description: []
) = {
  set block(below: 1.5em) 

  grid(
    columns: (1fr, auto),
    gutter: 5pt,
    align(left)[
      #text(fill: color-text-dark, weight: "bold", size: 12pt)[#title]
    ],
    align(right)[
      #text(fill: color-text-gray, size: 10pt, style: "italic")[#date]
    ]
  )

  text(fill: color-text-gray, size: 10pt, weight: "medium")[#company]

  set text(fill: color-text-dark, size: 10pt)
  pad(top: 0.5em, description)
}

#let certificate-entry(name, issuer, date) = {
  set block(below: 1em)
  grid(
    columns: (1fr, auto),
    gutter: 5pt,
    align(left)[
      #text(fill: color-text-dark, weight: "bold", size: 11pt)[#name]
    ],
    align(right)[
      #text(fill: color-text-gray, size: 9pt, style: "italic")[#date]
    ]
  )
  text(fill: color-text-gray, size: 9pt)[#issuer]
}

#let project-entry(name, date, description) = {
  set block(below: 1em)
  grid(
    columns: (1fr, auto),
    gutter: 5pt,
    align(left)[
      #text(fill: color-text-dark, weight: "bold", size: 11pt)[#name]
    ],
    align(right)[
      #text(fill: color-text-gray, size: 9pt, style: "italic")[#date]
    ]
  )
  set text(fill: color-text-dark, size: 10pt)
  description
}

#let reference-item(name, company, phone, email) = {
  set text(fill: color-text-dark, size: 10pt)
  block[
    #text(weight: "bold", size: 11pt)[#name] \
    #text(fill: color-text-gray)[#company] \
    #v(0.4em)
    #text(weight: "bold", size: 9pt)[Phone:] #phone \
    #text(weight: "bold", size: 9pt)[Email:] #email
  ]
}

#let resume(
  author: (:),
  profile-picture: none,
  sidebar-content: [],
  body
) = {
  set page(
    paper: "a4",
    margin: (left: 0cm, right: 0cm, top: 0cm, bottom: 0cm), 
    background: place(left, rect(fill: color-sidebar-bg, width: 32%, height: 100%))
  )

  set text(font: font-body, size: 10pt)

  grid(
    columns: (32%, 68%),

    block(
      height: 100%,
      inset: (top: 2cm, bottom: 2cm, left: 0.8cm, right: 0.8cm),

      {
        if profile-picture != none {
          align(center)[
            #block(
              width: 4.5cm, 
              height: 4.5cm, 
              radius: 50%,
              clip: true, // Crop the image into a circle
              fill: white, // Background in case of transparent PNG
              stroke: 10pt + color-profile-ring, // THE THICK BLUE RING
              profile-picture
            )
          ]
        }

        v(0.5cm)

        set align(left)

        sidebar-header("Contact")

        let contact-item(icn, content, link-target: none) = {
          grid(
            columns: (15pt, 1fr),
            gutter: 10pt,
            align: horizon,
            align(center, icon(icn)),
            if link-target != none {
              link(link-target)[#text(fill: color-text-white, size: 9pt)[#content]]
            } else {
              text(fill: color-text-white, size: 9pt)[#content]
            }
          )
          v(5pt)
        }

        if "email" in author { 
          contact-item("envelope", author.email, link-target: "mailto:" + author.email) 
        }
        if "phone" in author { 
          contact-item("phone", author.phone, link-target: "tel:" + author.phone) 
        }
        if "address" in author { 
          contact-item("location-dot", author.address) 
        }
        if "website" in author { 
          contact-item("globe", author.website, link-target: "https://" + author.website) 
        }
        if "github" in author {
           contact-item("github", "github.com/" + author.github, link-target: "https://github.com/" + author.github)
        }
        if "linkedin" in author {
           contact-item("linkedin", "linkedin.com/in/" + author.linkedin, link-target: "https://www.linkedin.com/in/" + author.linkedin)
        }

        sidebar-content
      }
    ),

    block(
      height: 100%,
      inset: (top: 2cm, bottom: 2cm, left: 1.2cm, right: 1.2cm),
      align(left)[
        #text(fill: color-text-dark, weight: "black", size: 36pt, font: font-heading)[
          #author.firstname #author.lastname
        ]
        #v(-5pt)
        #text(fill: color-text-dark, size: 16pt)[
          #author.positions.at(0)
        ]
        #v(1cm)
        #body
      ]
    )
  )
}
