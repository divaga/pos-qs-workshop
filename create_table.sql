CREATE TABLE public.kota (
    provinsi text,
    nama_kota text,
    latitude numeric(8,5),
    longitude numeric(8,5)
);

CREATE TABLE public.realisasi (
nama_kota text,
nama_penerima text,
jumlah_realisasi integer
);

CREATE TABLE public.alokasi (
nama_kota text,
jumlah_alokasi integer
);
