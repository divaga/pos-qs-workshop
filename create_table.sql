CREATE TABLE public.kota (
    provinsi text,
    nama_kota text,
    latitude numeric(5,2),
    longitude numeric(5,2)
);

CREATE TABLE public.realisasi (
nama_kota text,
nama_penerima text,
jumlah_realisasi numeric(5,2)
);

CREATE TABLE public.alokasi (
nama_kota text,
jumlah_alokasi numeric(5,2)
);
