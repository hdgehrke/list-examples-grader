CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

set -e

files=`find student-submission`
for file in $files
do
    if [[ -f $file ]] && [[ $file == */ListExamples.java ]]
    then 
        # run stuff
        cp $file grading-area
    fi
done

files2=`find lib`
for file in $files2
do
    if [[ -f $file ]] && [[ $file == *.jar ]]
    then
        cp $file grading-area
    fi
done

cp TestListExamples.java grading-area
cd grading-area/
set +e

### above this is fine

javac -cp hamcrest-core-1.3.jar junit-4.13.2.jar TestListExamples.java

for file in `ls`
do
    if [[ $file != *jar ]]
    then
        echo $file
        javac $file
    fi
done

: '
for file in `find grading-area/`
do 
    echo $file
done


javac TestListExamples.java
if [[ $? != 0 ]]
then 
    echo "The tester did not compile"
    exit
fi

javac $studentFile
if [[ $? != 0 ]]
then 
    echo "The submitted code did not compile"
    exit
fi
'