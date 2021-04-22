### daniel vogler
### generate pdf with shuffled questions

source local.defs

mkdir ${exam_folder}

#### read out participant names
student_names=()
while read student
do
    student_names+=($student)
done < $student_list

### read out exercises to incorporate
exercises=()
while read exercise
do
    exercises+=($exercise)
done < $exercise_list

### name of final test
test_all="${exam_folder}${exam_name}"
#rm -f ${test_all}*

### generate test for each student
for s in ${student_names[@]}; do

	### individualized test for student
	test_student="${test_all}_${s}.tex"
	cp $base $test_student

  ### populate tex file
  echo "\title{${exam_title}}" >> $test_student
  echo "\author{${exam_author}}" >> $test_student
  echo "\date{${exam_date}}\n" >> $test_student
  echo "\begin{document}\n" >> $test_student
  echo "\maketitle\n" >> $test_student

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

### delete files from tex compile
rm -f ${test_all}*log
rm -f ${test_all}*aux
rm -f ${test_all}*tex
