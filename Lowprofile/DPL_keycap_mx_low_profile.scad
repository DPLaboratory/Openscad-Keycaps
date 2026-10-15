// KEA-style keycap, Cherry MX compatible (spacing MX: 18mm cap, 19.05mm pitch)
// Altezza totale 5 mm, nessun labbro.
// Bordo superiore selezionabile: smussato a 45 gradi oppure arrotondato.
//
// r2: aggiunta la generazione di un intero set di keycap a partire dall'array "keys".
// r4: aggiunti ponticelli sottili tra gli stem dei keycap del set (link_mode) per migliorare
//     l'aderenza al piatto di stampa.

$fn = 64;

// ---------- Modalita' di costruzione ----------
build_mode = "set";   // "single" = un solo keycap (usa key_text e key_u)
                      // "set"    = un keycap per ogni elemento dell'array "keys"

// ---------- Parametri principali ----------
pitch      = 17.05;   // passo MX
gap        = 1.5;    // spazio tra keycap (19.05 - 18.00)
key_u      = 1;       // larghezza in unita' (1, 1.25, 1.5, ...) - solo build_mode = "single"
cap_w      = pitch * key_u - gap;  // 18.00 per 1u
cap_d      = pitch - gap;          // 18.00
cap_h      = 5.0;     // altezza totale
cap_h_out  = 2.0;     // = cap_h full wall 
corner_r   = 2.5;     // raggio angoli alla base
wall       = 1.4;     // spessore pareti
top_t      = 1.2;     // spessore del tetto (sotto il piano superiore)


// ---------- Bordo superiore ----------
edge_style = "round"; // "chamfer" = smusso 45 gradi | "round" = arrotondato (raccordo)
edge_size  = 1.2;       // dimensione: smusso 1.2mm orizz. x 1.2mm vert., oppure raggio 1.2mm
                        // piano superiore = 18 - 2*edge_size = 15.6 mm
round_steps = 12;       // risoluzione dell'arrotondamento (piu' alto = piu' liscio)

// ---------- Dish (cavita' circolare) ----------
dish_dia   = 15.0;    // diametro cerchio visto dall'alto (< 18 - 2*edge_size)
dish_depth = 0;       // 0.5 profondita' al centro (< top_t!)  | 0 = piano superiore piatto

// ---------- Testo ----------
text_mode     = "flat";  // "none" | "flat" (rilievo con sommita' piatta) | "engraved" (scavato)
text_color    = "white";    // colore del testo (modalita' flat): e' l'unica parte colorata
key_text      = "A";     // testo da riportare sul tasto - solo build_mode = "single"
text_size     = 3;       // altezza lettere (mm)
text_font     = "Britannic:style=Bold"; // Liberation Sans:style=Bold
text_spacing  = 1;       // spaziatura tra lettere (1 = normale)
text_rotate   = 0;       // rotazione in gradi
text_offset   = [0, 0];  // spostamento [x, y] dal centro (mm)
text_raise    = 0.0;     // "flat": quanto sporge sopra il piano superiore (mm)
text_engrave  = 0.2;     // "engraved": profondita' sotto il fondo del dish (mm)
line_spacing  = 1.2;   // interlinea, come multiplo di tsize

// ---------- Set di keycap ----------
// Ogni elemento di "keys" puo' essere:
//   "Q"                  -> keycap 1u con il testo "Q"
//   ["Tab", 1.5]         -> keycap larga 1.5u con il testo "Tab"
//   ["Esc", 1.25, 4.5]   -> come sopra, con altezza testo forzata a 4.5 mm

sep_char = "|";

numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];

numbers_shifted = ["!|1", "@|2", "#|3", "$|4", "%|5", "^|6", "&|7", "*|8", "(|9", ")|0"];

letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
           "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];

// Caratteri speciali (layout US/ANSI)
special = ["`", "-", "=", "[", "]", "\\", ";", "'", ",", ".", "/"];

// Caratteri ottenuti con Shift (se ti servono come legende secondarie)
shifted = ["~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+",
           "{", "}", "|", ":", "\"", "<", ">", "?"];
 
func = ["Fn1", "Fn2", "Fn3", "Fn4|Ent"];  
           
enter = ["↵"]; 

// Tutto insieme
// keys = concat(numbers, letters, special);
//keys = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", ["Tab", 1.5], ["Esc", 1]];
//keys = ["", "", [""], [""], [""], "", "", [""], [""], [""], [""], [""]];

keys = concat(numbers ,numbers_shifted, letters, func);

set_cols       = 6;      // keycap per riga sul piatto di stampa
set_gap        = 3;      // spazio tra i keycap sul piatto (mm)
auto_fit_text  = true;   // riduce il testo se non entra nella faccia superiore
text_char_w    = 0.7;    // larghezza media di un carattere = text_char_w * size (stima per il fit)
text_margin    = 0.5;    // margine libero ai lati del testo (mm)

// ---------- Collegamento tra keycap (aderenza al piatto) ----------
// Ponticelli sottili al livello del piatto che uniscono gli stem dei keycap vicini.
// Gli stem sono l'unica parte a contatto col piatto: collegandoli si aumenta la superficie
// del primo strato. Le croci degli stem restano libere. Dopo la stampa si tagliano via.
link_mode = "grid";   // "none" = nessun collegamento
                      // "rows" = collega ogni keycap al successivo nella stessa riga
                      // "grid" = come "rows" + collega ogni keycap a quello nella riga sotto
link_h    = 0.4;      // altezza ponticelli (mm): 1-2 strati, facili da staccare
link_w    = 2.0;      // larghezza ponticelli (mm)

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

// ---------- Funzioni per il set ----------
function key_label(k) = is_list(k) ? str(k[0]) : str(k);
function key_units(k) = (is_list(k) && len(k) > 1) ? k[1] : 1;
function key_width(k) = pitch * key_units(k) - gap;

// altezza del testo: forzata (3o elemento) oppure ridotta per entrare nella faccia superiore
function fit_size(label, w) =
    let(est   = len(label) * text_size * text_char_w,
        avail = w - 2 * edge_size - 2 * text_margin)
    (auto_fit_text && est > avail) ? text_size * avail / est : text_size;
function key_tsize(k) = (is_list(k) && len(k) > 2) ? k[2]
                                                   : fit_size(key_label(k), key_width(k));

// posizione sul piatto: i keycap sono affiancati per riga, con larghezze diverse
function row_start(i) = floor(i / set_cols) * set_cols;
function sum_w(from, to) = from >= to ? 0
                                      : key_width(keys[from]) + set_gap + sum_w(from + 1, to);
function key_x(i) = sum_w(row_start(i), i) + key_width(keys[i]) / 2;
function key_y(i) = -floor(i / set_cols) * (cap_d + set_gap);

// ---------- Moduli ----------
module rsq(w, d, r, h = 0.01) {
    linear_extrude(h)
        offset(r) square([w - 2*r, d - 2*r], center = true);
}

module edge_slice(i, w) {
    s = inset(i);
    translate([0, 0, wall_h + rise(i) - 0.01])
        rsq(w - 2*s, cap_d - 2*s, max(corner_r - s, 0.5), 0.01);
}

// corpo esterno: pareti dritte + bordo superiore (smusso o raccordo)
module outer_body(w) {
    //rsq(w, cap_d, corner_r, wall_h);
    
    translate([0, 0, wall_h - cap_h_out])
    rsq(w, cap_d, corner_r, cap_h_out);
    
    for (i = [0 : steps - 1])
      hull() { edge_slice(i, w); edge_slice(i + 1, w); }
}

module dish() {
    R = (pow(dish_dia/2, 2) + pow(dish_depth, 2)) / (2 * dish_depth);
    translate([0, 0, cap_h + R - dish_depth]) sphere(r = R, $fn = 160);
}

// cavita' a croce dello stem (usata anche per tenere libera la croce nei ponticelli)
module stem_cross() {
    translate([0, 0, -0.01]) {
        translate([-(cross_len + tol)/2, -(cross_wid + tol)/2, 0])
            cube([cross_len + tol, cross_wid + tol, stem_h]);
        translate([-(cross_wid + tol)/2, -(cross_len + tol)/2, 0])
            cube([cross_wid + tol, cross_len + tol, stem_h]);
    }
}

module stem() {
    difference() {
        cylinder(d = stem_d, h = ceil_h + 0.2);
        stem_cross();
    }
}

// funzioni split caratteri
function join(l, i=0) = i >= len(l) ? "" : str(l[i], join(l, i+1));
function substr(s, st, n) = n <= 0 ? "" : join([for (i=[st:st+n-1]) s[i]]);

function split(s, sep="|", i=0, start=0, acc=[]) =
    i == len(s) ? concat(acc, [substr(s, start, i-start)]) :
    s[i] == sep ? split(s, sep, i+1, i+1, concat(acc, [substr(s, start, i-start)])) :
    split(s, sep, i+1, start, acc);
    
// sagoma 2D del testo, centrata
module text2d(label, tsize) {
    lines = is_list(label) ? label : split(label, sep_char);
    n = len(lines);

    translate(text_offset)
        rotate(text_rotate)
            for (i = [0 : n-1])
                translate([0, ((n-1)/2 - i) * tsize * line_spacing])
                    text(lines[i], size = tsize, font = text_font,
                         halign = "center", valign = "center",
                         spacing = text_spacing);
                         
//    translate(text_offset)
//        rotate(text_rotate)
//            text(label, size = tsize, font = text_font,
//                 halign = "center", valign = "center", spacing = text_spacing);
}

// quota del fondo del dish al centro
dish_floor = cap_h - dish_depth;

// singolo keycap: testo, larghezza in unita' e altezza testo sono parametri
module keycap(label = key_text, u = key_u, tsize = text_size) {
    w = pitch * u - gap;

    // controllo: in modalita' scavato deve restare materiale sopra la cavita'
    if (text_mode == "engraved")
        assert(dish_floor - text_engrave > ceil_h + 0.2,
               "text_engrave troppo profondo: il tetto diventa troppo sottile");

    union() {
        difference() {
            outer_body(w);
            // cavita' interna (pareti dritte)
            translate([0, 0, -0.01])
                rsq(w - 2*wall, cap_d - 2*wall,
                    max(corner_r - wall, 0.5), ceil_h + 0.01);
            if (dish_depth > 0) dish();
            // testo scavato: fondo piatto
            if (text_mode == "engraved")
                translate([0, 0, dish_floor - text_engrave])
                    color(text_color) linear_extrude(text_engrave + dish_depth + 1) text2d(label, tsize);
        }
        stem();
        // testo in rilievo: sommita' piatta, parte da dentro il dish
        if (text_mode == "flat")
            color(text_color)
                translate([0, 0, cap_h] )
                    linear_extrude(cap_h + text_raise - (dish_floor - 0.1)) text2d(label, tsize);
    }
}

// set completo: un keycap per ogni elemento di "keys", disposti a griglia sul piatto
module keycap_set() {
    for (i = [0 : len(keys) - 1]) {
        k = keys[i];
        translate([key_x(i), key_y(i), 0])
            keycap(key_label(k), key_units(k), key_tsize(k));
    }
}

// ponticello piatto tra due punti [x, y] (centri degli stem)
module link(a, b) {
    hull() {
        translate([a[0], a[1], cap_h-link_h]) cylinder(d = link_w, h = link_h, $fn = 24);
        translate([b[0], b[1], cap_h-link_h]) cylinder(d = link_w, h = link_h, $fn = 24);
    }
}

// ponticelli tra gli stem dei keycap del set, sul piano del piatto (z = 0..link_h)
module keycap_links() {
    n = len(keys);
    // i ponticelli corrono sotto le pareti: non devono chiudere la cavita' del keycap
    assert(wall_h - cap_h_out >= link_h + 0.2,
           "link_h troppo alto: i ponticelli toccherebbero le pareti dei keycap");
           
    margin_x_row = round(pitch / 2) - link_w;
    margin_x_col = round(pitch / 2) - link_w;
    
    difference() {
        union() {
            for (i = [0 : n - 1]) {
                p_row = [key_x(i) + margin_x_row, key_y(i)];
                p_col = [key_x(i) , key_y(i) - margin_x_col];
                
                // keycap successivo nella stessa riga
                if (i + 1 < n && row_start(i + 1) == row_start(i))
                    link(p_row, [key_x(i + 1) - margin_x_row, key_y(i + 1)]);
                
                // keycap nella riga sotto
                if (link_mode == "grid" && i + set_cols < n)
                    link(p_col, [key_x(i + set_cols), key_y(i + set_cols) + margin_x_col]);
            }
        }
        // la croce di ogni stem resta libera
        for (i = [0 : n - 1])
            translate([key_x(i), key_y(i), 0]) stem_cross();
    }
}

// ---------- Output ----------
if (build_mode == "set") {
    keycap_set();
    if (link_mode != "none") keycap_links();
}
else keycap();
