// KEA-style keycap, Cherry MX compatible (spacing MX: 18mm cap, 19.05mm pitch)
// Altezza totale 5 mm, nessun labbro, bordo superiore smussato a 45 gradi.

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

// ---------- Smusso ----------
chamfer    = 1.2;     // smusso 45 gradi: 1.2mm in orizzontale = 1.2mm in verticale
                      // (piano superiore = 18 - 2*1.2 = 15.6 mm, come nel disegno)

// ---------- Dish (cavita' circolare) ----------
dish_dia   = 15.0;    // diametro cerchio visto dall'alto (< 18 - 2*chamfer)
dish_depth = 0.5;     // profondita' al centro (< top_t!)

// ---------- Stem Cherry MX ----------
stem_d      = 5.6;    // diametro esterno cilindro
stem_h      = 3.3;    // profondita' croce dal basso
cross_len   = 4.15;   // lunghezza braccio croce (nominale 4.1)
cross_wid   = 1.35;   // larghezza braccio croce (nominale 1.3-1.4)
tol         = 0.05;   // tolleranza stampa 3D

// ---------- Derivati ----------
ceil_h  = cap_h - top_t;                 // quota del soffitto della cavita'
wall_h  = cap_h - chamfer;               // altezza dove inizia lo smusso
top_r   = max(corner_r - chamfer, 0.5);  // raggio angoli in cima

// ---------- Moduli ----------
module rsq(w, d, r, h = 0.01) {
    linear_extrude(h)
        offset(r) square([w - 2*r, d - 2*r], center = true);
}

// corpo esterno: pareti dritte + smusso a 45 gradi in cima
module outer_body() {
    // parte dritta
    rsq(cap_w, cap_d, corner_r, wall_h);
    // parte smussata
    hull() {
        translate([0, 0, wall_h - 0.01]) rsq(cap_w, cap_d, corner_r, 0.01);
        translate([0, 0, cap_h - 0.01])
            rsq(cap_w - 2*chamfer, cap_d - 2*chamfer, top_r, 0.01);
    }
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

module keycap() {
    union() {
        difference() {
            outer_body();
            // cavita' interna (pareti dritte)
            translate([0, 0, -0.01])
                rsq(cap_w - 2*wall, cap_d - 2*wall,
                    max(corner_r - wall, 0.5), ceil_h + 0.01);
            dish();
        }
        stem();
    }
}

keycap();
