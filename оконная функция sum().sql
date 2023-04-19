select *, sum(amount) over() as total,
          sum(amount) over(partition by month(date)) as month_total,
          amount*100/sum(amount) over() as perc
from orders
where year(date)=2021;