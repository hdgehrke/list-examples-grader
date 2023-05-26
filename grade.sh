CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
# CPATH2='.:hamcrest-core-1.3.jar:junit-4.13.2.jar'
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
javac -cp .:hamcrest-core-1.3.jar:junit-4.13.2.jar *.java 2> output.txt
if [[ $? != 0 ]]
then 
    echo "The tester did not compile"
    cat output.txt
fi

for file in `ls`
do
    if [[ -f $file ]] && [[ $file == ListExamples.java ]]
    then 
        # run stuff
        java -cp .:hamcrest-core-1.3.jar:junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > output.txt
        if [[ $? != 0 ]]
        then 
            echo "The tests did not succeed"
        else
            echo "All tests succeeded!"
        fi
        testsRan=true
    fi
done

if [[ $testsRan = false ]]
then 
    echo "Missing the file 'ListExamples.java'" > output.txt
fi