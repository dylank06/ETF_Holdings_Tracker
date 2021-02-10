
CREATE TABLE stock (
    id SERIAL PRIMARY KEY,
    symbol TEXT NOT NULL,
    name TEXT NOT NULL,
    exchange TEXT NOT NULL,
    is_etf BOOLEAN NOT NULL
);

CREATE TABLE etf_holding (
    etf_id INTEGER NOT NULL,
    holding_id INTEGER NOT NULL,
    dt DATE NOT NULL,
    shares NUMERIC,
    weight NUMERIC,
    PRIMARY KEY (etf_id, holding_id, dt),
    CONSTRAINT fk_etf FOREIGN KEY (holding_id) REFERENCES stock (id),
    CONSTRAINT fk_holding FOREIGN KEY (holding_id) REFERENCES stock (id)
);

CREATE TABLE stock_price (
    stock_id INTEGER NOT NULL,
    dt TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    open NUMERIC NOT NULL,
    high NUMERIC NOT NULL,
    low NUMERIC NOT NULL,
    close NUMERIC NOT NULL,
    volume NUMERIC NOT NULL,
    PRIMARY KEY (stock_id, dt),
    CONSTRAINT fk_stock FOREIGN KEY (stock_id) REFERENCES stock (id)
);

CREATE INDEX ON stock_price (stock_id, dt DESC);

SELECT create_hypertable('stock_price', 'dt');

/* For Ark ETFS */

UPDATE stock SET is_etf =TRUE
WHERE symbol IN ('ARKK', 'ARKQ', 'PRNT', 'ARKG', 'ARKF', 'ARKW')

/* After running populate etf */
select * from etf_holding

-- Examples of quereies to run on the data --
select * from etf_holding where dt ='2021-01-26';

select * from stock where id = 7315;

select * from etf_holding where etf_id = 7315 and dt = '2021-02-04'
select * from etf_holding where etf_id = 7315 and dt = '2021-02-08'

-- find added holdings --
select holding_id
from etf_holding 
where dt = '2021-02-08'
and holding not in (select * from etf_holding where etf_id = 7315 and dt = '2021-02-08'))

-- find the name of stock that was added
select * from stock where id = 15117;


select *
from etf_holding
order by etf_id, holding_id, dt;

select * from stock where id IN(7317, 13774)