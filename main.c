#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <syslog.h>
#include <sys/wait.h>

#define TESTING 0

int run_script();

int times_run = 0;

int main(int argc, char **argv)
{
    float WAIT_TIME = 120.0f;
    if (argc > 1)
        sscanf(argv[1], "%f", &WAIT_TIME); // This causes a coredump.

    time_t rawtime;
    struct timespec sleep_time, current;
    struct timespec wait;
    run_script();
    // Daemonize the program
    daemon(0,0);
    // Daemon loop.
    while (1)
    {
        time(&rawtime);
        clock_gettime(CLOCK_REALTIME, &current);
        //while (rawtime%((int)WAIT_TIME) != 0 || current.tv_nsec > 100000000L)
        while (rawtime%((int)WAIT_TIME) != 0)
        {
            wait.tv_nsec = 1100000000L - current.tv_nsec;
            wait.tv_sec = (WAIT_TIME-1) - rawtime%((int)WAIT_TIME);

            syslog(LOG_NOTICE, "BG Daemon waiting %ld.%9ld second(s)...", wait.tv_sec, wait.tv_nsec);

            nanosleep(&wait, NULL);

            time(&rawtime);
            clock_gettime(CLOCK_REALTIME, &current);
        }
        // Generate a child, then a grandchild, to run the background script.
        pid_t pid = fork();
        if (pid == 0)
        {
            pid = fork();
            //run_script();
            if (pid == 0)
            {
                execlp("randomize-background", "randomize-background", (char *) NULL);
                _exit(EXIT_SUCCESS);
            } else if (pid == -1)
            {
                _exit(EXIT_FAILURE);
            }
            times_run++;
            _exit(EXIT_SUCCESS);
        } else if (pid != -1)
        {
            waitpid(pid, NULL, 0);
        } else {
            exit(EXIT_FAILURE);
        }

        sleep_time.tv_nsec = 1100000000L - current.tv_nsec;
        sleep_time.tv_sec = (WAIT_TIME-1) - rawtime%((int)WAIT_TIME);

        syslog(LOG_NOTICE, "BG Daemon Alive! Sleeping for %ld.%9ld seconds...", sleep_time.tv_sec, sleep_time.tv_nsec);

        nanosleep(&sleep_time, NULL);

        if (TESTING && times_run>=3) exit(0);
    }
    return 0;
}

int run_script()
{
    pid_t pid;
    // Fork
    pid = fork();
    // An error occurred
    if (pid < 0)
        exit(EXIT_FAILURE);
    // Success: let the parent return.
    if (pid > 0)
        return 0;
    // Execute the background randomizer script.
    /*syslog(LOG_NOTICE, "BG Daemon changing desktop background...");*/
    execlp("randomize-background", "randomize-background", (char *) NULL);
    _exit(EXIT_SUCCESS);
}
