# Projekat Čitač Bar-kodova

## Pregled
Ovaj projekat je čitač barkodova koji obrađuje i dekodira bar-kodove iz slika. Projekat uključuje funkcije za rotiranje, isecanje i čitanje bar-kodova, i sadrži grafički korisnički interfejs (GUI) razvijen pomoću MATLAB-ovog GUIDE alata. 

## Karakteristike
- **Učitaj sliku:** Omogućava korisnicima da pretraže i učitaju sliku koja sadrži bar-kod.
- **Rotiraj bar-kod:** Automatski rotira bar-kod kako bi bio horizontalno poravnat.
- **Iseci bar-kod:** Omogućava korisnicima da ručno iseku područje bar-koda sa slike.
- **Pročitaj bar-kod:** Dekodira bar-kod sa obrađene slike.

## Funkcije

### `rotate_barcode`
Rotira ulaznu sliku kako bi bar-kod bio horizontalno poravnat.

```matlab
function [rotatedImg, angle] = rotate_barcode(img)
```

- **Ulaz:** `img` - Ulazna slika koja sadrži bar-kod.
- **Izlaz:** `rotatedImg` - Rotirana slika sa horizontalno poravnatim bar-kodom, `angle` - Ugao za koji je slika rotirana.

### `read_barcode`
Čita bar-kod sa slike koristeći više linija skeniranja.

```matlab
function [bar_code, found] = read_barcode(I)
```

- **Ulaz:** `I` - Ulazna slika
- **Izlaz:** `bar_code` - Dekodirani bar-kod, `found` - Indikator da li je bar-kod pronađen (1) ili ne (0).


## Pomoćne Funkcije

### `manual_rotate`
Rotira sliku za određeni ugao sa datom bojom pozadine.

```matlab
function rotatedImg = manual_rotate(img, angle, bgColor)
```

- **Ulaz:** `img` - Ulazna slika, `angle` - Ugao rotacije u stepenima, `bgColor` - Boja pozadine za popunjavanje praznih prostora nakon rotacije.
- **Izlaz:** `rotatedImg` - Rotirana slika sa specificiranom bojom pozadine.

### `decode_bar_EAN_13`
Dekodira dati EAN-13 bar-kod string u njegovu numeričku reprezentaciju.

```matlab
function [code, flag] = decode_bar_EAN_13(bcode)
```

- **Ulaz:** `bcode` - Ulazni bar-kod kao binarni string.
- **Izlaz:** `code` - Dekodirani bar-kod kao vektor cifara, `flag` - Indikator da li je bar-kod ispravno dekodiran (1) ili ne (0).

### `cutoff_histogram`
Skraćuje histogram uklanjanjem nula na kraju.

```matlab
function [cut_hist] = cutoff_histogram(hist)
```

- **Ulaz:** `hist` - Ulazni histogram.
- **Izlaz:** `cut_hist` - Skraćeni histogram sa uklonjenim nultim vrednostima na kraju.

### `find_base_peak`
Određuje osnovnu vršnu dužinu za modul poređenjem prvih vrhova histogram bele i crne dužine.

```matlab
function [base_peak, found] = find_base_peak(len_peaks_w, len_peaks_b)
```

- **Ulaz:** `len_peaks_w` - Niz dužina vrhova za bele segmente, `len_peaks_b` - Niz dužina vrhova za crne segmente.
- **Izlaz:** `base_peak` - Izračunata osnovna vršna dužina za modul, `found` - Indikator da li je pronađena validna osnovna vršna dužina (1) ili ne (0).

### `make_histograms`
Pravi histograme dužina segmenata belih i crnih piksela iz binarizovane linije slike.

```matlab
function [len_list, len_hist_w, len_hist_b] = make_histograms(bin_line)
```

- **Ulaz:** `bin_line` - Binarizovana linija (niz) piksela.
- **Izlaz:** `len_list` - Lista dužina segmenata piksela iste boje, `len_hist_w` - Histogram dužina belih piksela, `len_hist_b` - Histogram dužina crnih piksela.

### `find_peaks`
Identifikuje vrhove u histogramu.

```matlab
function [peaks] = find_peaks(hist)
```

- **Ulaz:** `hist` - Ulazni histogram.
- **Izlaz:** `peaks` - Indeksi vrhova u histogramu.

### `find_modules`
Izračunava dužine modula na osnovu osnovnog vrha i vrhova u histogramima dužina belih i crnih piksela.

```matlab
function [modules] = find_modules(base_peak, peaks_w, peaks_b)
```

- **Ulaz:** `base_peak` - Osnovna vršna dužina za modul, `peaks_w` - Niz dužina vrhova za bele segmente, `peaks_b` - Niz dužina vrhova za crne segmente.
- **Izlaz:** `modules` - Izračunate dužine modula.

## Korišćenje GUI-a
1. **Učitaj sliku:** Kliknite na dugme "Učitaj sliku" da biste pretražili i odabrali sliku koja sadrži bar-kod.
2. **Rotiraj bar-kod:** Kliknite na dugme "Rotiraj bar-kod" da automatski poravnate bar-kod horizontalno.
3. **Iseci bar-kod:** Kliknite na dugme "Iseci bar-kod" i odaberite područje bar-koda na slici pomoću miša.
4. **Pročitaj bar-kod:** Kliknite na dugme "Pročitaj bar-kod" da dekodirate bar-kod sa obrađene slike.

## Zahtevi
- MATLAB sa Image Processing Toolbox-om
- GUIDE (za grafički korisnički interfejs)

## Kako Pokrenuti
1. Otvorite MATLAB.
2. Pokrenite skriptu `main.m` da biste pokrenuli GUI.
3. Koristite dugmice da učitate, rotirate, isecate i čitate barkod sa slike.
