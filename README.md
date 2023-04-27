# DSCI-D532 Final Project: D&D 5e Database 

## Purpose

My app is called the D&D 5e Monsters Database. I created it so dungeon masters (DMs), players, and other Dungeons & Dragons enthusiasts can find information on monsters that they are interested in. Users can either look up a monster they have in mind by name, or sort and filter through different options to find new ones that they might be interested in. My web app allows users to customize how they view this information, so they only have the information they want.

## How the project was built 

The backend of my project was built with R, and I used the RSQLite package to manage my SQLite database. The database was stored locally on my computer. I used another R package called Shiny to build my app and then deployed it to ShinyApps.io, which is a PaaS that hosts Shiny apps. I used HTML and Bootswatch to customize the appearance of my web app. 

## Data

I got my raw data from the “DnD 5e Monsters” dataset on Kaggle. Originally, the dataset was a table with 17 columns and 762 rows. Each row represents a different, unique creature. The data had both missing and poorly formatted values. Using SQLite, I converted certain text columns into numeric columns, replaced empty string values in url with NAs, split speed and type into multiple columns, and improved the formatting with name. Once I was done, I was left with a table with 762 rows and 19 columns. 

## Functionalities

My application allows users to sort, filter, and search through a table of D&D monsters. It also allows them to choose what rows or columns they want excluded from their results. Rows can be excluded based on some pre-defined database views I created (whether a URL or combat stats are missing), and columns can be individually excluded by unselecting specific checkboxes. I also created a “Monster Info Sheet” creator which generates a customizable information sheet for a specified monster. By selecting which set of variables to include, users can select what information they want displayed for a creature.

## Data Source
https://www.kaggle.com/datasets/mrpantherson/dnd-5e-monsters?datasetId=835454
