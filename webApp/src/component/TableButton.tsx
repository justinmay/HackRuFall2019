import React from 'react'; 
import '../stylesheets/TableButton.css';

type TableButtonState = {
}

type TableButtonProps = {
    name: string,
    onClick(): void,
}

class Tables extends React.Component<TableButtonProps,TableButtonState>{
    render() {
        return(
            <button className="button" onClick={this.props.onClick}>
                Table: {this.props.name}
            </button>
        )
    }
}

export default Tables;
