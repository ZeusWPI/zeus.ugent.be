---
title: C review
description: We hebben even wat dingen in C geschreven, en dit zijn onze meningen
created_at: 23-10-2016
---

> *Ben ik nu echt de enige die C echt niet leuk vindt?*
>
> <small>&mdash; Ilion Iasoon Beyst</small>

C is een toffe taal enal

~~~
Individual *genetic_algo(Area *area, StationCol *stations, double lo, double hi) {
    // Initialize global variables
    init_coverage_polygon(area);
    MAX_POWER = power_to_energy_usage(43);

    Population* p = generate_initial_population(POPULATION_SIZE, stations);
    recalculate_fitness(area, stations, p, lo, hi);

    Individual* best = genetic_algo_exec(p, area, stations, POPULATION_SIZE, lo, hi, clock());
    for (size_t i = 0; i < best->size; i++) {
        printf("%d\n", best->distribution[i]);
    }
    printf("%f\n", calculate_energy_usage(stations, best));
    printf("%f\n", calculate_station_coverage(area, stations, best, NULL));

    for (size_t i = 0; i < p->size; i++) {
        individual__free(p->elems[i]);
    }
    population__free(p);

    return best;
}
~~~
