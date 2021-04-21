### daniel vogler
### generate pdf with shuffled questions

mkdir "./exams/"

### file in student names for individualized tests
student_names=("Smith" "Miller" "Hightower" "Baxter" "Gorin")

### main file that is populated with randomized test questions
base="master_exam"

### name of final test
exam_folder="./exams/"
test_all="${exam_folder}exam"
rm -f ${test_all}*

### exercise files to incorporate into main test
exercises=("ex_a" "ex_b" "ex_c" "ex_d" "ex_e" "ex_f" "ex_g")

### generate test for each student
for s in ${student_names[@]}; do
	
	### individualized test for student
	test_student="${test_all}_${s}.tex"
	cp $base $test_student

	### randomize exercises
	rand_exercises=( $(shuf -e "${exercises[@]}") )
	
	### loop through all exercises
	i=0
	for e in ${rand_exercises[@]}; do
		i=$((i+1))

		### append randomized questions to base file
		echo "\paragraph{Question $i} " >> $test_student 
		echo "\input{./exercises/$e.tex} " >> $test_student
	done

	echo "\end{document}" >> $test_student
	
	pdflatex -interaction batchmode -output-directory $exam_folder $test_student

done

### delte all files except pdf-files
rm -f ${test_all}*log
rm -f ${test_all}*aux
rm -f ${test_all}*tex



