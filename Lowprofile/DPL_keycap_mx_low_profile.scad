// KEA-style keycap, Cherry MX compatible (spacing MX: 18mm cap, 19.05mm pitch)
// Altezza totale 5 mm, nessun labbro.
// Bordo superiore selezionabile: smussato a 45 gradi oppure arrotondato.

$fn = 64;

// ---------- Parametri principali ----------
pitch      = 19.05;   // passo MX
gap        = 1.05;    // spazio tra keycap (19.05 - 18.00)
key_u      = 1;       // larghezza in unita' (1, 1.25, 1.5, ...)
cap_w      = pitch * key_u - gap;  // 18.00 per 1u
cap_d      = pitch - gap;          // 18.00
cap_h      = 5.0;     // altezza totale
corner_r   = 2.5;     // raggio angoli alla base
wall       = 1.4;     // spessore pareti
top_t      = 1.2;     // spessore del tetto (sotto il piano superiore)

// ---------- Bordo superiore ----------
edge_style = "chamfer"; // "chamfer" = smusso 45 gradi | "round" = arrotondato (raccordo)
edge_size  = 1.2;       // dimensione: smusso 1.2mm orizz. x 1.2mm vert., oppure raggio 1.2mm
                        // piano superiore = 18 - 2*edge_size = 15.6 mm
round_steps = 12;       // risoluzione dell'arrotondamento (piu' alto = piu' liscio)

// ---------- Dish (cavita' circolare) ----------
dish_dia   = 15.0;    // diametro cerchio visto dall'alto (< 18 - 2*edge_size)
dish_depth = 0.5;     // profondita' al centro (< top_t!)

// ---------- Testo ----------
text_mode     = "none";  // "none" | "flat" (rilievo con sommita' piatta) | "engraved" (scavato)
key_text      = "A";     // testo da riportare sul tasto
text_size     = 6;       // altezza lettere (mm)
text_font     = "Liberation Sans:style=Bold";
text_spacing  = 1;       // spaziatura tra lettere (1 = normale)
text_rotate   = 0;       // rotazione in gradi
text_offset   = [0, 0];  // spostamento [x, y] dal centro (mm)
text_raise    = 0.4;     // "flat": quanto sporge sopra il piano superiore (mm)
text_engrave  = 0.3;     // "engraved": profondita' sotto il fondo del dish (mm)

// ---------- Stem Cherry MX ----------
stem_d      = 5.6;    // diametro esterno cilindro
stem_h      = 3.3;    // profondita' croce dal basso
cross_len   = 4.15;   // lunghezza braccio croce (nominale 4.1)
cross_wid   = 1.35;   // larghezza braccio croce (nominale 1.3-1.4)
tol         = 0.05;   // tolleranza stampa 3D

// ---------- Derivati ----------
ceil_h = cap_h - top_t;       // quota del soffitto della cavita'
wall_h = cap_h - edge_size;   // altezza dove inizia il bordo
is_round = (edge_style == "round");
steps  = is_round ? round_steps : 1;

// rientro orizzontale e quota verticale al passo i (0..steps)
function inset(i) = is_round ? edge_size * (1 - cos(90 * i / steps))
                             : edge_size * i / steps;
function rise(i)  = is_round ? edge_size * sin(90 * i / steps)
                             : edge_size * i / steps;

// ---------- Moduli ----------
module rsq(w, d, r, h = 0.01) {
    linear_extrude(h)
        offset(r) square([w - 2*r, d - 2*r], center = true);
}

module edge_slice(i) {
    s = inset(i);
    translate([0, 0, wall_h + rise(i) - 0.01])
        rsq(cap_w - 2*s, cap_d - 2*s, max(corner_r - s, 0.5), 0.01);
}

// corpo esterno: pareti dritte + bordo superiore (smusso o raccordo)
module outer_body() {
    rsq(cap_w, cap_d, corner_r, wall_h);
    for (i = [0 : steps - 1])
        hull() { edge_slice(i); edge_slice(i + 1); }
}

module dish() {
    R = (pow(dish_dia/2, 2) + pow(dish_depth, 2)) / (2 * dish_depth);
    translate([0, 0, cap_h + R - dish_depth]) sphere(r = R, $fn = 160);
}

module stem() {
    difference() {
        cylinder(d = stem_d, h = ceil_h + 0.2);
        translate([0, 0, -0.01]) {
            translate([-(cross_len + tol)/2, -(cross_wid + tol)/2, 0])
                cube([cross_len + tol, cross_wid + tol, stem_h]);
            translate([-(cross_wid + tol)/2, -(cross_len + tol)/2, 0])
                cube([cross_wid + tol, cross_len + tol, stem_h]);
        }
    }
}

// sagoma 2D del testo, centrata
module text2d() {
    translate(text_offset)
        rotate(text_rotate)
            text(key_text, size = text_size, font = text_font,
                 halign = "center", valign = "center", spacing = text_spacing);
}

// quota del fondo del dish al centro
dish_floor = cap_h - dish_depth;

module keycap() {
    // controllo: in modalita' scavato deve restare materiale sopra la cavita'
    if (text_mode == "engraved")
        assert(dish_floor - text_engrave > ceil_h + 0.2,
               "text_engrave troppo profondo: il tetto diventa troppo sottile");

    union() {
        difference() {
            outer_body();
            // cavita' interna (pareti dritte)
            translate([0, 0, -0.01])
                rsq(cap_w - 2*wall, cap_d - 2*wall,
                    max(corner_r - wall, 0.5), ceil_h + 0.01);
            dish();
            // testo scavato: fondo piatto
            if (text_mode == "engraved")
                translate([0, 0, dish_floor - text_engrave])
                    linear_extrude(text_engrave + dish_depth + 1) text2d();
        }
        stem();
        // testo in rilievo: sommita' piatta, parte da dentro il dish
        if (text_mode == "flat")
            translate([0, 0, dish_floor - 0.1])
                linear_extrude(cap_h + text_raise - (dish_floor - 0.1)) text2d();
    }
}

keycap();
