import React from 'react'; 
import MenuItem from './MenuItem';
import '../stylesheets/TableView.css';
import {Table, Menu} from './Home';

type TableViewState = {
    currentTableID: number,
    menus: Menu[],
}

type TableViewProps = {
    tables: Table[],
    menus: Menu[],
    currentTableID: number,
    axios: any,
    url: string,
}

class TableView extends React.Component<TableViewProps,TableViewState>{
    constructor(props: TableViewProps) {
        super(props)
        this.state={
            currentTableID: this.props.currentTableID,
            menus: this.props.menus,
        };
        this.updateMenu = this.updateMenu.bind(this);
    }

    componentDidUpdate(prevProps: TableViewProps, prevState: TableViewState) {
        if (prevState.menus !== this.state.menus) {
          this.setState({menus: this.state.menus});
        }
    }

    static getDerivedStateFromProps(nextProps: TableViewProps,prevState: TableViewState) {
        if(nextProps.currentTableID !== prevState.currentTableID) {
            return {currentTableID: nextProps.currentTableID}
        } 
        else if (nextProps.menus !== prevState.menus) {
            console.log("updating",nextProps.menus)
            return {menu: nextProps.menus}
        } else return null;
    }

    updateMenu(name: string, modifier: number) {
        console.log(name,modifier)
        const menus = this.state.menus;
        /** find the right menu */
        for(let i = 0;i < menus.length; i++) {
            if(menus[i].key === this.state.currentTableID) {
                /** find the right item */
                for(let j = 0;j <menus[i].items.length; j++) {
                    if(menus[i].items[j].name === name) {
                        menus[i].items[j].quantity += modifier
                        break;
                    }
                }
                break;
            }
        }
        this.setState({menus});
    }

    getCurrentMenu(): Menu {
        console.log("menus",this.state.menus, this.state.currentTableID)
        this.state.menus.find(menu => {
            return menu.key === this.state.currentTableID
        });
        return {items:[],key:0}
    }

    /** FULL SEND */
    sendIt() {
        this.state.menus.forEach(menu => {
            if(menu.key === this.state.currentTableID) {
                this.props.axios.post(`${this.props.url}/restaurants/1/tables/${this.state.currentTableID}/submit`, menu.items)
                .then((response: any) => {
                    console.log(response);
                }, (error: any) => {
                    console.log(error);
          });
            }
        }) 
    }

    /** CLEAR IT */
    clearIt() {
        this.state.menus.forEach(menu => {
            if(menu.key === this.state.currentTableID) {
                this.props.axios.post(`${this.props.url}/restaurants/1/tables/${this.state.currentTableID}/finish`, menu.items)
                .then((response: any) => {
                    console.log(response);
                }, (error: any) => {
                    console.log(error);
          });
            }
        }) 
    }

    render() {
        return(
            <div className="TableView">
                <div className="TableInformation">
                    <div>
                        <h3>
                            Table {this.state.currentTableID}
                        </h3>
                    </div>
                    <div style={{display:"flex",flexDirection:"row"}}>
                        <button className="checkout" onClick={() => this.sendIt()}>
                            Checkout 
                        </button>
                        <button className="checkout" style={{marginLeft: "10px"}}onClick={() => this.clearIt()}>
                            Finish 
                        </button>
                    </div>
                </div>
                <div className="menu">
                    {this.state.menus.map(menu => {
                        if(menu.key === this.state.currentTableID){
                            return menu.items.map(item => {
                                return <MenuItem
                                    name={item.name}
                                    image={item.string}
                                    status=""
                                    quantity={item.quantity}
                                    updateQuantity={this.updateMenu}
                                    key={item.name}
                                />
                            })
                        }
                        return null
                    })}
                </div>
            </div>
        )
    }
}

export default TableView;
