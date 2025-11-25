#let cover_letter(
  sender: (:),
  recipient: (:),
  date: "",
  subject: "",
  salutation: "Dear Hiring Manager,",
  closing: "Sincerely,",
  signature: none,
  body
) = {
  // DIN 5008 Settings
  set page(
    paper: "a4",
    // Margins: Left 25mm for filing, Right 20mm.
    // Top/Bottom can vary, but we use absolute placement for headers/address.
    margin: (left: 25mm, right: 20mm, top: 20mm, bottom: 20mm),
  )

  set text(font: "Source Sans 3", size: 11pt, lang: "en", fill: black)
  set par(justify: true, leading: 0.65em)

  // --- 1. FOLDING MARKS (Falzmarken) ---
  // Placed relative to the page top-left corner
  //place(dx: -20mm, dy: -20mm)[ // Reset to 0,0 page coordinates
  //  #line(start: (0mm, 105mm), end: (5mm, 105mm), stroke: 0.5pt) // Fold 1
  //  #line(start: (0mm, 210mm), end: (5mm, 210mm), stroke: 0.5pt) // Fold 2
  //  #line(start: (0mm, 148.5mm), end: (8mm, 148.5mm), stroke: 0.5pt) // Punch mark (optional)
  //]

  // --- 2. SENDER HEADER (Form B: 0-45mm area) ---
  place(top + right, dy: 0mm)[
    #set align(right)
    #set text(size: 10pt) // Slightly smaller for header looks professional
    *#sender.name* \
    #sender.address \
    #sender.zip #sender.city \
    #sender.phone \
    #sender.email
  ]

  // --- 3. RECIPIENT BLOCK (Form B: Starts 45mm from top) ---
  // The address field is 40mm high + 5mm back-address zone above it.
  // Since our top margin is 20mm, we need dy: 25mm to hit 45mm absolute.
  place(top + left, dy: 25mm)[
    #block(width: 85mm, height: 45mm)[

      // A. Back Address (Rücksendeangabe) - Required for Window Envelopes
      //#set text(size: 7pt, weight: "regular")
      //#underline[#sender.name • #sender.address • #sender.zip #sender.city]

      #v(5mm) // Small visual gap

      // B. Recipient Address
      #set text(size: 11pt, weight: "regular")
      #recipient.company \
      #if "contact" in recipient [Attn: #recipient.contact \ ]
      #recipient.address \
      #recipient.zip #recipient.city
    ]
  ]

  // --- 4. DATE AND SUBJECT POSITIONING ---
  // We need to move below the address field (which ends at 45mm + 45mm = 90mm from top).
  // Standard content starts roughly at 98mm-100mm.
  // Current cursor is at top margin (20mm).
  // We add 80mm space to push pass the address block safely.
  v(65mm)

  // Date (Right aligned)
  align(right)[#date]

  // 2 Empty lines (DIN 5008)
  v(2em)

  // Subject (Bold)
  text(weight: "bold")[#subject]

  // 2 Empty lines (DIN 5008)
  v(2em)

  // Salutation
  salutation

  v(1em)

  // Body
  body

  v(1em)

  // Closing
  closing

  v(2.5cm)

  // Signature
  if signature != none {
    place(dx: 0mm, dy: -1.5cm, signature)
  }

  sender.name
}
