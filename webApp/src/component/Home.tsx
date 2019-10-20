import React from 'react'; 
import Nav from './NavBar';
import Tables from './Tables';
import TableView from './TableView';
import Lottie from 'react-lottie';
import animation from '../animation.json';
import star from '../star.json';
import '../stylesheets/Home.css';

type HomeState = {
    tables: Table[],
    axios: any,
    menus: Menu[],
    currentTableID: number,
    showTable: boolean,
    url: string,
    showStar: boolean,
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
    string: string,
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
            showTable: false,
            url: "https://2ca69306.ngrok.io",
            showStar: false,
        };
        this.setCurrentTableID = this.setCurrentTableID.bind(this);
        this.showStar=this.showStar.bind(this);
    }

    showStar() {
        this.setState({showStar: true})
    }

    /** Get table data from the Backend */
    getTables() {
        const self = this;
        this.state.axios.get(`${this.state.url}/restaurants/1/tables`)
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
        this.state.axios.get(`${this.state.url}/restaurants/1/items`)
        .then(function (response: any) {
            // handle success
            const items: Item[] = [];
            response.data.items.forEach((item: any) => {
                const tempItem: Item = {
                    name: item.name,
                    price: item.price,
                    quantity: 0,
                    string: item.image,
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
            console.log(menus)
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
                string: i.string
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
        const defaultOptions = {
            loop: true,
            autoplay: true, 
            animationData: animation,
            rendererSettings: {
              preserveAspectRatio: 'xMidYMid slice'
            }
          };

          const starOptions = {
            loop: true,
            autoplay: true, 
            animationData: star,
            rendererSettings: {
              preserveAspectRatio: 'xMidYMid slice'
            }
          };

        return(
            <div>
                <div style={{position:"absolute", left:0,bottom:0,width:"17vw"}}>
                    <Lottie options={defaultOptions}
                    />
                </div>
                <Nav/>
                <div className="view">
                    <Tables 
                        tables={this.state.tables}
                        setCurrentTable={this.setCurrentTableID}
                    />
                    {
                        this.state.showTable ? <TableView 
                        showStar={this.showStar}
                        menus={this.state.menus} 
                        tables={this.state.tables}
                        currentTableID={this.state.currentTableID}
                        axios={this.state.axios}
                        url={this.state.url}
                    /> : null
                    }
                    
                </div>
                {
                this.state.showStar ? 
                <button className="lottie" onClick={() => this.setState({showStar: false})}>
                    <Lottie options={starOptions}
                    />
                </button>: null
            }
            </div>
        )
    }
}

export default Home;
