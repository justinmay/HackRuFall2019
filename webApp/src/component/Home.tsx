import React from 'react'; 
import Nav from './NavBar';
import Tables from './Tables';
import TableView from './TableView';
import '../stylesheets/Home.css';

type HomeState = {
    tables: Table[],
    axios: any,
    menus: Menu[],
    currentTableID: number,
    showTable: boolean,
}

type HomeProps = {
}

export type Table = {
    numPeople: number,
    key: number,
}

export type Menu = {
    items: Item[],
    key: number,
}

export type Item = {
    name: string,
    price: string,
    quantity: number,
}

class Home extends React.Component<HomeProps,HomeState>{

    constructor(props: HomeProps) {
        super(props)

        const axios = require('axios').default;
        this.state ={
            axios,
            tables: [],
            menus: [],
            currentTableID: 1,
            showTable: false
        };
        this.setCurrentTableID = this.setCurrentTableID.bind(this);
    }

    /** Get table data from the Backend */
    getTables() {
        const self = this;
        this.state.axios.get('https://3e3f4486.ngrok.io/restaurants/1/tables')
        .then(function (response: any) {
            // handle success
            const tables = response.data.tables;
            const stateTables: Table[] = [];
            tables.forEach((element: any) => {
                const table: Table = {
                    numPeople: element.people.length,
                    key: element._id,
                }
                stateTables.push(table)
            });
            /** Get Menu */
            self.getMenu(stateTables)
        })
        .catch(function (error: any) {
            // handle error
            console.log(error);
        })
        .finally(function () {
            // always executed
        });
    }

    /** Get menu items  */
    getMenu(stateTables: Table[]){
        const self = this;
        this.state.axios.get('https://3e3f4486.ngrok.io/restaurants/1/items')
        .then(function (response: any) {
            // handle success
            const items: Item[] = [];
            response.data.items.forEach((item: any) => {
                const tempItem: Item = {
                    name: item.name,
                    price: item.price,
                    quantity: 0
                }
                items.push(tempItem)
            })
            const menus: Menu[] = [];
            stateTables.forEach( table => {
                const menu: Menu = {
                    key: table.key,
                    items: self.getCopyOfItems(items)
                }
                menus.push(menu)
            });
            self.setState({
                tables: stateTables,
                menus,
                showTable: true,
            });
        })
        .catch(function (error: any) {
            // handle error
            console.log(error);
        })
        .finally(function () {
            // always executed
        });
    }

    getCopyOfItems(items: Item[]) {
        const ret: Item[] = [];
        items.forEach(i => {
            const item: Item = {
                name: i.name,
                price: i.price,
                quantity: i.quantity,
            }
            ret.push(item)
        });
        return ret
    }

    componentDidMount() {
        this.getTables();
    }

    setCurrentTableID(currentTableID: number) {
        this.setState({
            currentTableID
        })
        console.log("new id", currentTableID)
    }


    render() {
        return(
            <div>
                <Nav/>
                <div className="view">
                    <Tables 
                        tables={this.state.tables}
                        setCurrentTable={this.setCurrentTableID}
                    />
                    {
                        this.state.showTable ? <TableView 
                        menus={this.state.menus} 
                        tables={this.state.tables}
                        currentTableID={this.state.currentTableID}
                        axios={this.state.axios}
                    /> : null
                    }
                    
                </div>
            </div>
        )
    }
}

export default Home;
