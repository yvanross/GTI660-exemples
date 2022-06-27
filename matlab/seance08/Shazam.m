% Get the list of reference tracks to add (URLs in this case, but
% filenames work too)
% tks= myls(['http://labrosa.ee.columbia.edu/~dpwe/tmp/Nine_Lives/*.mp3']);
tks= myls(['./audio-files/*.mp3']);
% Initialize the hash table database array
clear_hashtable
% Calculate the landmark hashes for each reference track and store
% it in the array (takes a few seconds per track).
add_tracks(tks);
% Load a query waveform (recorded from playback on a laptop)
[dt,srt] = mp3read('Q-full-circle.mp3');
% Run the query
R = match_query(dt,srt);
% R returns all the matches, sorted by match quality.  Each row
% describes a match with three numbers: the index of the item in
% the database that matches, the number of matching hash landmarks,
% and the time offset (in 32ms steps) between the beggining of the
% reference track and the beggining of the query audio.
R(1,:)
% 5 18 1 18 means tks{5} was matched with 18 matching landmarks, at a
% time skew of 1 frame (query starts ~ 0.032s after beginning of
% reference track), and a total of 18 hashes matched that track at
% any time skew (meaning that in this case all the matching hashes
% had the same time skew of 1).
%
% Plot the matches
illustrate_match(dt,srt,tks);
colormap(1-gray)
% This re-runs the match, then plots spectrograms of both query and
% the matching part of the reference, with the landmark pairs
% plotted on top in red, and the matching landmarks plotted in
% green.