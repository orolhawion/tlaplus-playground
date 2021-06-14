-------------------------------- MODULE Dice --------------------------------
EXTENDS Naturals, TLC
(* --algorithm Dice

variables 
    state \in { "steady", "rolling" },
    current \in 1..6;

begin
Roll:
    if state = "steady" then
        A: state := "rolling";
    end if;
    B: state := "steady";
    with result \in 1..6 do 
        current := result;
        print current;
    end with;
        
end algorithm *)

\* BEGIN TRANSLATION (chksum(pcal) = "58e5b60" /\ chksum(tla) = "684d86a5")
VARIABLES state, current, pc

vars == << state, current, pc >>

Init == (* Global variables *)
        /\ state \in { "steady", "rolling" }
        /\ current \in 1..6
        /\ pc = "Roll"

Roll == /\ pc = "Roll"
        /\ IF state = "steady"
              THEN /\ pc' = "A"
              ELSE /\ pc' = "B"
        /\ UNCHANGED << state, current >>

A == /\ pc = "A"
     /\ state' = "rolling"
     /\ pc' = "B"
     /\ UNCHANGED current

B == /\ pc = "B"
     /\ state' = "steady"
     /\ \E result \in 1..6:
          /\ current' = result
          /\ PrintT(current')
     /\ pc' = "Done"

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Roll \/ A \/ B
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

CurrentInRange == current \in 1..6 

=============================================================================
\* Modification History
\* Last modified Mon Jun 14 17:43:08 CEST 2021 by mts
\* Created Mon Jun 14 15:17:25 CEST 2021 by mts
