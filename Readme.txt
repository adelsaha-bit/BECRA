Read Me file.
This file contain algorithms and functions we used to obtain results of tables 1..9, and benchmarks.

 This code is the implementation of Face to face comparison between ACO2OPT and BECRA2OPT
1.First we apply the ACO metaheuristic , if you want to change the benchmark:
In ACO code Change the name of benchmark in model1=CreateD_Set('kroA100.tsp'); 
Replace kroA100.tsp by eil76.tsp for example.
 
2.Then EXCHANGE2 (apply 2opt on ACO's Solution) and we have ACO2OPT solution.
3. BECRA2OPT apply BECRA procedure on tour variable constructed by ACO and generates 10 solutions (It=10).
if you want to generate X solution by BEFRA go to: bestgraph function and replace k=10 (line 23) by the number you desire in the interval mentioned in the paper. As result we have BECRA best solution.
 
4. We apply 2opt heuristique (opt2becra code), we have BECRA2OPT best solution.
5. We return and save the 4 values of ACO,ACO2OPT,BECRA and BECRA2OPT in results_ACO.mat file


