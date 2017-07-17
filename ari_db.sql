--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aircraft_crewmember; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE aircraft_crewmember (
    aircraft_id integer NOT NULL,
    crewmember_id integer NOT NULL
);


ALTER TABLE aircraft_crewmember OWNER TO postgres;

--
-- Name: aircrafts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE aircrafts (
    id integer NOT NULL,
    aircraft text NOT NULL
);


ALTER TABLE aircrafts OWNER TO postgres;

--
-- Name: aircrafts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE aircrafts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aircrafts_id_seq OWNER TO postgres;

--
-- Name: aircrafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE aircrafts_id_seq OWNED BY aircrafts.id;


--
-- Name: crew_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE crew_members (
    id integer NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    dob date NOT NULL
);


ALTER TABLE crew_members OWNER TO postgres;

--
-- Name: crew_members_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE crew_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE crew_members_id_seq OWNER TO postgres;

--
-- Name: crew_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE crew_members_id_seq OWNED BY crew_members.id;


--
-- Name: aircrafts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY aircrafts ALTER COLUMN id SET DEFAULT nextval('aircrafts_id_seq'::regclass);


--
-- Name: crew_members id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY crew_members ALTER COLUMN id SET DEFAULT nextval('crew_members_id_seq'::regclass);


--
-- Data for Name: aircraft_crewmember; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY aircraft_crewmember (aircraft_id, crewmember_id) FROM stdin;
1	1
4	4
2	5
3	3
5	2
5	3
3	4
3	5
1	5
6	6
6	5
5	6
\.


--
-- Data for Name: aircrafts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY aircrafts (id, aircraft) FROM stdin;
1	Spirit of St. Louis
2	USS Enterprise \\(NCC-1701-D\\)
3	Red Dwarf
4	USCSS Nostromo
5	Wine Bottle
6	Millennium Falcon
\.


--
-- Name: aircrafts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('aircrafts_id_seq', 6, true);


--
-- Data for Name: crew_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY crew_members (id, name, surname, dob) FROM stdin;
1	Charles	Lindbergh	1902-11-16
2	Vladimir	ćeks	1943-01-22
3	Arnold	Rimmer	1968-02-28
4	Ellen	Ripley	1973-06-02
5	Jean-Luc	Picard	1973-06-01
6	Han	Solo	1972-08-13
7	Chewbacca		1970-12-03
\.


--
-- Name: crew_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('crew_members_id_seq', 7, true);


--
-- Name: aircraft_crewmember aircraft_crewmember_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY aircraft_crewmember
    ADD CONSTRAINT aircraft_crewmember_pkey PRIMARY KEY (aircraft_id, crewmember_id);


--
-- Name: aircrafts aircrafts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY aircrafts
    ADD CONSTRAINT aircrafts_pkey PRIMARY KEY (id);


--
-- Name: crew_members crew_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY crew_members
    ADD CONSTRAINT crew_members_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

-- •	Find name of the oldest crew member
-- SELECT CONCAT(name, ' ', surname) FROM crew_members ORDER BY dob ASC LIMIT 1;


-- •	Find name of the n-th crew member (second oldest, fifth oldest and so on)
-- SELECT CONCAT(name, ' ', surname) FROM crew_members ORDER BY dob ASC LIMIT 1 OFFSET 4; --5th


--•	Find name of the most experienced crew member - that one who knows most aircrafts
-- SELECT CONCAT(a.name,' ', a.surname) as name FROM crew_members a 
-- LEFT JOIN
-- (
-- 		SELECT crewmember_id, COUNT(crewmember_id) as most_exp 
-- 		FROM aircraft_crewmember
-- 		GROUP BY crewmember_id 
-- ) as b 
-- ON a.id = b.crewmember_id 
-- WHERE COALESCE(b.most_exp, 0) = 
-- (
-- 		SELECT MAX(most_exp) FROM 
-- 		(
-- 			SELECT crewmember_id, COUNT(crewmember_id) as most_exp 
-- 			FROM aircraft_crewmember x
-- 			RIGHT JOIN crew_members y ON x.crewmember_id = y.id
-- 			GROUP BY crewmember_id
-- 		) as f
-- );


--•	Find name of the least experienced crew member - that one who knows least aircrafts (counting from zero)
-- SELECT CONCAT(a.name,' ', a.surname) as name FROM crew_members a 
-- LEFT JOIN
-- (
-- 		SELECT crewmember_id, COUNT(crewmember_id) as most_exp 
-- 		FROM aircraft_crewmember
-- 		GROUP BY crewmember_id 
-- ) as b 
-- ON a.id = b.crewmember_id 
-- WHERE COALESCE(b.most_exp, 0) = 
-- (
-- 		SELECT MIN(most_exp) FROM 
-- 		(
-- 			SELECT crewmember_id, COUNT(crewmember_id) as most_exp 
-- 			FROM aircraft_crewmember x
-- 			RIGHT JOIN crew_members y ON x.crewmember_id = y.id
-- 			GROUP BY crewmember_id
-- 		) as f
-- );
