# STAT 172 Final Project
This is my final project for STAT 172. 

## Dataset Choice
For this project, I chose to analyze the 2026 Stack Overflow Developer Survey dataset. You can find the original dataset archive [here](https://github.com/StackExchange/Survey/tree/main/packages/archive/2026). I will specifically be focusing on whether the developer said that they use AI in their work or not.

## Before You Begin
Before you can run this project, you will need the following:
* R version 4.3.1 or later
* Git
* RStudio (optional, but recommended)
* Stack Overflow Developer Survey 2026 dataset (The file name is `survey_results_public.csv`)

### Packages
This project uses an `renv` to manage packages to keep them consistent across different machines. When you open R, the environment will check to make sure that you have `renv` installed. If `renv` is not installed, the activation script will install it for you. It will even ask you if you would like to install the packages that are needed for this project if they are not already installed. In the event that it does not prompt you to install the packages, please run the following command in the R console.
```R
renv::restore()
```






## License
This R project is licensed under the GNU General Public License v3.0 Only. See the [LICENSE](LICENSE) file for more details.

## Data Attribution
The data used in this project was published by Stack Overflow under the [Open Database License (ODbL) 1.0](https://opendatacommons.org/licenses/odbl/1-0/); individual cell contents under the [Database Contents License (DbCL) 1.0](https://opendatacommons.org/licenses/dbcl/1-0/).

**Attribution**: _Stack Overflow Developer Survey_, Stack Exchange Inc.

The survey data used in this project is subject to its original licensing terms, independently of the licensed used for this project's source code. 