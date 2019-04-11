import numpy as np
import csv
import random


def gen_trials(e, Nt, Ne, td):
    """TODO: Docstring for gen_trials.

    :e: TODO
    :Nt: TODO
    :Ne: TODO
    :td: TODO
    :returns: TODO

    """
    # target events
    target = np.repeat(e, int(td * Nt))
    # non-target events
    ntarget = np.repeat(np.setdiff1d(np.arange(Ne), e), (Nt - int(td * Nt)) / (Ne - 1))
    i_place = 3 * np.array(random.sample(list(range(1, (Nt // 3))), len(target)))
    print(i_place)
    # join and shuffle
    np.random.shuffle(ntarget)
    seq = np.concatenate((target, ntarget))
    for i, j in enumerate(i_place):
        if i != j:
            tmp = seq[j]
            seq[j] = seq[i]
            seq[i] = tmp

    return seq


Ntrials = 40
Nevents = 5
Nunique = 5
Nnoise = 3
target_d = 0.2
stim_t = 100
t_rand = 150

SOA = 1500
ISI = SOA - stim_t


event_list = [[0, 0, 0, 0, 0, 0, 0]]
noise_event = np.arange(Nnoise)
t = 3000
# t = 0

event_array = np.mod(list(range(Nevents)), Nunique)
np.random.shuffle(event_array)
for i in event_array:
    # t += event_list[-1][-1] + 3000
    # event_list.append([t, "", i, "/instruction", i, "", 10000])
    np.random.shuffle(noise_event)
    for k in range(Nnoise):
        t += event_list[-1][-1] + 5000
        event_list.append([t, "", i, "/instruction", i, "", 5000])
        t += event_list[-1][-1] + 1000
        event_list.append([t, "", "", "/sound", 0, noise_event[k], 3000])
        tr = gen_trials(i, Ntrials, Nunique, target_d)
        # print(np.shape(tr))
        for j in range(Ntrials):
            t += event_list[-1][-1] + ISI + int(np.random.uniform(-t_rand, t_rand))
            event_list.append([t, 0, tr[j], "/oddball", i, noise_event[k], stim_t])
            # print([0,t[j],i,noise_event[k],stim_t])

del event_list[0]

with open("events.csv", "w", newline="") as myfile:
    wr = csv.writer(myfile)
    wr.writerows(event_list)

print(np.array(event_list))
print(len(event_list))
